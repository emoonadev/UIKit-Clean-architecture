//
// Created by Mickael Belhassen on 17/03/2022.
//

import UIKit

class AlertBuilder {

    private var alert: UIAlertController


    init(title: String? = nil, message: String? = nil, style: UIAlertController.Style = .alert) {
        self.alert = UIAlertController(title: title, message: message, preferredStyle: style)
    }

}


// MARK: - Methods

extension AlertBuilder {

    @discardableResult
    func positiveAction(title: String, action: ((_ action: UIAlertAction, _ alertController: UIAlertController) -> ())? = nil) -> AlertBuilder {
        alert.addAction(UIAlertAction(title: title, style: .default) { [self] in action?($0, alert) })
        return self
    }

    @discardableResult
    func negativeAction(title: String, action: ((_ action: UIAlertAction) -> ())? = nil) -> AlertBuilder {
        alert.addAction(UIAlertAction(title: title, style: .cancel, handler: action))
        return self
    }

    @discardableResult
    func destroyAction(title: String, action: ((_ action: UIAlertAction) -> ())? = nil) -> AlertBuilder {
        alert.addAction(UIAlertAction(title: title, style: .destructive, handler: action))
        return self
    }

    @discardableResult
    func addTextField(configurationHandler: ((UITextField) -> Void)? = nil) -> AlertBuilder {
        alert.addTextField(configurationHandler: configurationHandler)
        return self
    }

    func build() -> UIAlertController {
        return alert
    }

}


// MARK: - Extension

extension UIAlertController {

    func show(in viewController: UIViewController) {
        viewController.present(self, animated: true)
    }

}

