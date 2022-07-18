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
        bindViewState()
    }

    func appDataSynced() {
        loadCustomers()
    }
    
    func bindViewState() {
        viewState.$addBtnDidClick.observe(on: self) { (self, _) in
            self.openCreateCustomerScreen()
        }
        
        viewState.$lastSelectedCustomer.observe(on: self) { (self, customer) in
            guard let customer = customer else { return }
            self.openProfileScreen(of: customer)
        }
    }
    
    func initVC() {
        loadCustomers()
    }
    
    private func loadCustomers() {
        viewState.customers.value = customerRepository.getLocalCustomers()
    }

}

// MARK: UI Interaction / data

private extension CustomersListViewModel {

    func openProfileScreen(of customer: Customer) {
        router.openProfile(of: customer)
    }

    func openCreateCustomerScreen() {
        router.openAddCustomer(completion: loadCustomers)
    }

}
