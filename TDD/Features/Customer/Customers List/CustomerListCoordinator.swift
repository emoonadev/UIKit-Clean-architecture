//
// Created by Mickael Belhassen on 04/05/2022.
//

import Foundation

protocol CustomerListCoordinatorService: NavigationCoordinator {
    func openProfile(of customer: Customer)
    func openAddCustomer(completion: @escaping () -> ())
}

struct CustomerListCoordinator: CustomerListCoordinatorService {
    var direction: Observable<NavigationDirection?> = .init(nil)

    func openProfile(of customer: Customer) {
        direction.value = .forward(destination: .customerProfile(customer), style: .push)
    }

    func openAddCustomer(completion: @escaping () -> ()) {
        direction.value = .forward(destination: .addCustomerViewController(completion), style: .present(.automatic))
    }
}
