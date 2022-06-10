//
// Created by Mickael Belhassen on 14/03/2022.
//

import SwiftUI
import Foundation

protocol NameableInjection: AnyObject {
    static var className: String { get }
}

extension NameableInjection {
    static var className: String { NSStringFromClass(self).components(separatedBy: ".").last! }
}

protocol Resolver {
    func resolve<T>() -> T
    func resolve<T>(_ type: T.Type) -> T
}

public struct DependencyInjector {

    public enum InstanceType {
        case single, new
    }

    static var dependencies: Resolver = DependencyFactory()

    private init() {}

}

public class BaseContainer {
    @objc dynamic open func registerDependencies() {}
}

public class DependencyFactory: BaseContainer, Resolver {

    private var services = [String: () -> Any]()
    private var singleServices = [String: Any]()
    private var tmpSingleServices = [String: () -> Any]() // This dictionary contains instance singles which are Lazy. The sinigle inistance will be unique instantiate by the first caller


    override init() {
        super.init()
        registerDependencies()
    }

}


// MARK: Resolver / Register

extension DependencyFactory {

    public func resolve<T>() -> T {
        return resolve(T.self)
    }

    public func resolve<T>(_ type: T.Type) -> T {
        let serviceName = String(describing: type)
        return resolve(serviceName: serviceName)
    }

    func resolve<T: NameableInjection>(_ type: T.Type) -> T {
        return resolve(serviceName: type.className)
    }

    public func resolve<T>(serviceName: String) -> T {
        if let tmpService = tmpSingleServices[serviceName]?() as? T {
            singleServices[serviceName] = tmpService
            tmpSingleServices.removeValue(forKey: serviceName)
            return tmpService
        }

        if let service = (services[serviceName]?() ?? singleServices[serviceName]) as? T {
            return service
        }

        fatalError("\(serviceName) not registered. Make sure that you are trying to resolve services already registered. The order of service registration is important")
    }

    public func register<T>(_ type: T.Type = T.self, instanceType: DependencyInjector.InstanceType = .new, apply: @escaping (DependencyFactory) -> T) {
        let serviceName = String(describing: T.self).components(separatedBy: ".")[0]
        register(serviceName: serviceName, instanceType: instanceType, apply: apply)
    }

    func register<T: NameableInjection>(_ type: T.Type = T.self, instanceType: DependencyInjector.InstanceType = .new, apply: @escaping (DependencyFactory) -> T) {
        register(serviceName: type.className, instanceType: instanceType, apply: apply)
    }

    public func register<T>(serviceName: String, instanceType: DependencyInjector.InstanceType = .new, apply: @escaping (DependencyFactory) -> T) {
        guard !isExist(in: services, for: serviceName) || !isExist(in: singleServices, for: serviceName) || !isExist(in: tmpSingleServices, for: serviceName) else { fatalError("\(serviceName) already registered. Only one registration can be made per dependency") }

        if instanceType == .new {
            services[serviceName] = { apply(self) }
        } else {
            tmpSingleServices[serviceName] = { apply(self) }
        }
    }

    private func isExist(in services: [String: Any], for key: String) -> Bool {
        return services.first { $0.key == key } != nil
    }

    public func autoResolve<T>(_ initializer: () -> T) -> T { initializer() }
    public func autoResolve<T, A>(_ initializer: (A) -> T) -> T { initializer(resolve()) }
    public func autoResolve<T, A, B>(_ initializer: (A, B) -> T) -> T { initializer(resolve(), resolve()) }
    public func autoResolve<T, A, B, C>(_ initializer: (A, B, C) -> T) -> T { initializer(resolve(), resolve(), resolve()) }
    public func autoResolve<T, A, B, C, D>(_ initializer: (A, B, C, D) -> T) -> T { initializer(resolve(), resolve(), resolve(), resolve()) }
    public func autoResolve<T, A, B, C, D, E>(_ initializer: (A, B, C, D, E) -> T) -> T { initializer(resolve(), resolve(), resolve(), resolve(), resolve()) }

}

@propertyWrapper
struct LazyResolve<T> {

    lazy var service: T = DependencyInjector.dependencies.resolve()

    var wrappedValue: T {
        mutating get {
            return service
        }
        set {
            service = newValue
        }
    }

}

@propertyWrapper
public struct Resolve<T> {
    var service: T = DependencyInjector.dependencies.resolve()
    
    public init() {}

    public var wrappedValue: T {
        get { return service }
        set { service = newValue }
    }
}

// https://github.com/hmlongco/Resolver/blob/master/Sources/Resolver/Resolver.swift
@propertyWrapper
public struct OptionalResolve<T> {
    private var service: T?

    public init() {
        service = DependencyInjector.dependencies.resolve(T.self)
    }

    public var wrappedValue: T? {
        get { return service }
        mutating set { service = newValue }
    }
}

@propertyWrapper
public struct EnvironmentObservedResolve<T: ObservableObject>: DynamicProperty {

    @ObservedObject private var _service: T

    public var wrappedValue: T {
        _service
    }

    public init() {
        self.__service = ObservedObject<T>(initialValue: DependencyInjector.dependencies.resolve())
    }

    public var projectedValue: ObservedObject<T>.Wrapper {
        return __service.projectedValue
    }

}

@propertyWrapper
public struct StateObjectResolve<T: ObservableObject>: DynamicProperty {

    @StateObject private var _service: T

    public var wrappedValue: T {
        _service
    }

    public init() {
        self.__service = StateObject<T>(wrappedValue: DependencyInjector.dependencies.resolve())
    }

    public var projectedValue: ObservedObject<T>.Wrapper {
        return __service.projectedValue
    }

}
