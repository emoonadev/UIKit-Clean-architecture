//
// Created by Mickael Belhassen on 17/03/2022.
//

import UIKit

extension UIViewController {

    func showAlert(error: Error) {
        AlertBuilder(title: .k.error, message: error.localizedDescription, style: .alert)
                .positiveAction(title: .k.done)
                .build()
                .show(in: self)
    }

}
