//
// Created by Mickael Belhassen on 14/03/2022.
//

import Foundation

class CustomersListViewModel {
    private let customerRepository: CustomerRepositoryService
    let router: CustomerListCoordinatorService
    let viewState: CustomerListViewState

    init(router: CustomerListCoordinatorService, customerRepository: CustomerRepositoryService, viewState: CustomerListViewState) {
        self.customerRepository = customerRepository
        self.router = router
        self.viewState = viewState
        setup()
    }

    deinit {
        EMEventCenter.shared.removeObserver(self)
    }
}

// MARK: - Setup

extension CustomersListViewModel: EMEventCenterDelegate {

    func setup() {
        EMEventCenter.shared.addObserver(self)
    }

    func appDataSynced() {
        loadCustomers()
    }

}

// MARK: UI Interaction/ data

extension CustomersListViewModel {

    func loadCustomers() {
        viewState.customers.value = customerRepository.getLocalCustomers()
    }

    func openProfileScreen(of customer: Customer) {
        router.openProfile(of: customer)
    }

    func openCreateCustomerScreen() {
        router.openAddCustomer(completion: loadCustomers)
    }

}