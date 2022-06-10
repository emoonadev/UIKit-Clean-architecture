//
// Created by Mickael Belhassen on 04/05/2022.
//

import Foundation

import UIKit

enum NavigationDirection {
    case back
    case forward(destination: NavigationDestination, style: NavigationStyle)

    enum NavigationStyle {
        case push
        case present(PresentationStyle)

        enum PresentationStyle {
            case automatic, fullScreen
        }
    }
}

protocol NavigationCoordinator {
    var direction: Observable<NavigationDirection?> { get set }
}

extension NavigationCoordinator {
    func callAsFunction() -> Observable<NavigationDirection?> { direction }
}

protocol Routable {
    associatedtype T: NavigationCoordinator
    var router: T { get }
}

extension Routable {
    func callAsFunction() -> Observable<NavigationDirection?> { router() }
}

fileprivate final class NavigationHandler {
    var navigationDirection: Observable<NavigationDirection?>
    private var destination: NavigationDestination?
    private unowned var viewController: UIViewController

    init(navigationDirection: Observable<NavigationDirection?>, viewController: UIViewController) {
        self.navigationDirection = navigationDirection
        self.viewController = viewController
    }

    func startObserving() {
        navigationDirection.observe(on: self) { (self, direction) in
            switch direction {
                case .back:
                    if let navigationController = self.viewController.navigationController {
                        navigationController.popViewController(animated: true)
                    } else {
                        self.viewController.dismiss(animated: true)
                    }
                case .forward(let destination, let style):
                    self.destination = destination

                    switch style {
                        case .push:
                            self.viewController.navigationController?.pushViewController(destination.viewController, animated: true)
                        case .present(let style):
                            switch style {
                                case .automatic:
                                    self.viewController.modalPresentationStyle = .automatic
                                case .fullScreen:
                                    self.viewController.modalPresentationStyle = .fullScreen
                            }

                            self.viewController.present(destination.viewController, animated: true, completion: nil)
                    }
                case .none:
                    break
            }
        }
    }
}

extension UIViewController {
    private static let association = ObjectAssociation<NavigationHandler>()

    fileprivate var navigationHandler: NavigationHandler? {
        get { return UIViewController.association[self] }
        set { UIViewController.association[self] = newValue }
    }

    func handleNavigation(_ navigationDirection: Observable<NavigationDirection?>) {
        navigationHandler = NavigationHandler(navigationDirection: navigationDirection, viewController: self)
        navigationHandler?.startObserving()
    }

}

fileprivate final class ObjectAssociation<T: AnyObject> {
    private let policy: objc_AssociationPolicy

    public init(policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        self.policy = policy
    }

    public subscript(index: AnyObject) -> T? {
        get { return objc_getAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque()) as! T? }
        set { objc_setAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque(), newValue, policy) }
    }
}

