//
// Created by Mickael Belhassen on 14/03/2022.
//

import Foundation

struct AddCustomerViewModel {
    let router: AddCustomerCoordinatorService
    let customerRepository: CustomerRepositoryService

    var customerDidCreate: (() -> ())?

    @Observable(TDError.invalidName) var error: Error // Need to be in view state!!!!


    init(router: AddCustomerCoordinatorService, customerRepository: CustomerRepositoryService) {
        self.customerRepository = customerRepository
        self.router = router
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