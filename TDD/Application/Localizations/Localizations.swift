//
// Created by Mickael Belhassen on 17/03/2022.
//

import Foundation

struct KString {
    let error = "Error"
    let done = "Done"

    let customersListViewControllerToAddCustomerViewController = "CustomersListViewController.AddCustomerViewController"
    let customersListViewControllerToCustomerProfileViewController = "CustomersListViewController.CustomerProfileViewController"
}

extension String {

    static let k = KString()

}