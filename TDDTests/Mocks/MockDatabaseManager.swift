//
// Created by Mickael Belhassen on 16/03/2022.
//

import Foundation

class MockDatabaseManager: DatabaseManagerService {
    var customers: [Customer] = []

    func getCustomers() -> [Customer] {
        customers
    }

    func addCustomer(_ customer: Customer) {
        customers.append(customer)
    }

    func deleteCustomer(_ customer: Customer) {
        customers.removeAll { $0.name == customer.name }
    }

}
