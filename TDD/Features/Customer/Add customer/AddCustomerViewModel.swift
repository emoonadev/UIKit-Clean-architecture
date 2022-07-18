//
// Created by Mickael Belhassen on 14/03/2022.
//

import Foundation

final class AddCustomerViewModel {
    let router: AddCustomerCoordinatorService
    let customerRepository: CustomerRepositoryService
    let viewState: AddCustomerViewStateService

    var customerDidCreate: (() -> Void)?

    @Observable(TDError.invalidName) var error: Error

    init(router: AddCustomerCoordinatorService, customerRepository: CustomerRepositoryService, viewState: AddCustomerViewStateService) {
        self.customerRepository = customerRepository
        self.router = router
        self.viewState = viewState
        setup()
    }
}

// MARK: - Setup

private extension AddCustomerViewModel {

    func setup() {
        setViewStateObservers()
    }

    func setViewStateObservers() {
        viewState.customerNameToCreate.observe(on: self) { (self, customerName) in
            guard let customerName = customerName else { return }
            self.createCustomer(with: customerName)
        }

        viewState.cancelActionDidClick.observe(on: self) { (self, _) in
            self.router.dismiss()
        }
    }

}

// MARK: - UI Interaction

extension AddCustomerViewModel {

    func createCustomer(with name: String) {
        do {
            try customerRepository.createCustomer(with: name)
            customerDidCreate?()
            router.dismiss()
        } catch {
            self.error = error
        }
    }

}
