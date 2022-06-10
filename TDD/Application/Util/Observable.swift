//
// Created by Mickael Belhassen on 14/03/2022.
//

import Foundation

@propertyWrapper
public class Observable<Input> {
    typealias Observer = (Input) -> Bool

    private var observers: [Observer]
    private let safeQueue = DispatchQueue(label: "com.observable.value", attributes: .concurrent)
    private var _value: Input
    public var projectedValue: Observable<Input> { safeQueue.sync { self } }

    public var wrappedValue: Input {
        get {
            safeQueue.sync { _value }
        }
        set {
            value = newValue
        }
    }

    public var value: Input {
        get {
            safeQueue.sync { _value }
        }
        set {
            safeQueue.async(flags: .barrier) {
                self._value = newValue
                self.notifyObservers(newValue)
            }
        }
    }

    public init(_ value: Input) {
        _value = value
        observers = []
    }

    func observe<Target: AnyObject>(on target: Target, observer: @escaping (Target, Input) -> Void) {
        safeQueue.async(flags: .barrier) {
            let observer: Observer = { [weak target] input in
                guard let target = target else { return false }
                observer(target, input)
                return true
            }

            self.observers.append(observer)
        }
    }

    func setValue(_ newValue: Input) {
        safeQueue.async(flags: .barrier) {
            self._value = newValue
        }
    }

    private func notifyObservers(_ value: Input) {
        DispatchQueue.main.async {
            self.safeQueue.sync {
                let _ = self.observers.filter { $0(value) }
            }
        }
    }

    func bind<O: AnyObject, T>(_ sourceKeyPath: KeyPath<Input, T>, to object: O, _ objectKeyPath: ReferenceWritableKeyPath<O, T>) {
        observe(on: object) { object, observed in
            let value = observed[keyPath: sourceKeyPath]
            object[keyPath: objectKeyPath] = value
        }
    }

    func bind<O: AnyObject, T>(_ sourceKeyPath: KeyPath<Input, T>, to object: O, _ objectKeyPath: ReferenceWritableKeyPath<O, T?>) {
        observe(on: object) { object, observed in
            let value = observed[keyPath: sourceKeyPath]
            object[keyPath: objectKeyPath] = value
        }
    }

    func bind<O: AnyObject, T, R>(_ sourceKeyPath: KeyPath<Input, T>, to object: O, _ objectKeyPath: ReferenceWritableKeyPath<O, R?>, transform: @escaping (T) -> R?) {
        observe(on: object) { object, observed in
            let value = observed[keyPath: sourceKeyPath]
            let transformed = transform(value)
            object[keyPath: objectKeyPath] = transformed
        }
    }

}
