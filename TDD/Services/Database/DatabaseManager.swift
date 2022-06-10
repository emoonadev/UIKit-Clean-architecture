//
// Created by Mickael Belhassen on 14/03/2022.
//

import Foundation

protocol DatabaseManagerService {
    func getCustomers() -> [Customer]
    func addCustomer(_ customer: Customer)
    func deleteCustomer(_ customer: Customer)
}

final class DatabaseManager: DatabaseManagerService {
    private var defaultCustomers: [Customer] = [.init(name: try! .init("MyDefault name"))]

    func getCustomers() -> [Customer] {
        defaultCustomers
    }

    func addCustomer(_ customer: Customer) {
        defaultCustomers.append(customer)
    }

    func deleteCustomer(_ customer: Customer) {
        defaultCustomers.removeAll { $0.name == customer.name }
    }

}
