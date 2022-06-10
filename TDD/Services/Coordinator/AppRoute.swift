//
// Created by Mickael Belhassen on 04/05/2022.
//

import UIKit

enum NavigationDestination {
    case customerList
    case customerProfile(Customer)
    case addCustomerViewController(() -> ())

    var viewController: UIViewController {
        switch self {
            case .customerList:
                return UINavigationController(rootViewController: CustomersListViewController())
            case .addCustomerViewController(let completion):
                let vc = AddCustomerViewController()
                vc.viewModel.customerDidCreate = completion
                return vc
            case .customerProfile(let customer):
                let vc = CustomerProfileViewController()
                vc.viewModel.customer = customer
                return vc
        }
    }
}