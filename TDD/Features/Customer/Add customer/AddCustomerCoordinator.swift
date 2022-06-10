//
// Created by Mickael Belhassen on 04/05/2022.
//

import Foundation

protocol AddCustomerCoordinatorService: NavigationCoordinator {
    func dismiss()
}

struct AddCustomerCoordinator: AddCustomerCoordinatorService {
    var direction: Observable<NavigationDirection?> = .init(nil)

    func dismiss() {
        direction.value = .back
    }
}
