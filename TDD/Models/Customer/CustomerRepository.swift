//
// Created by Mickael Belhassen on 14/03/2022.
//

import Foundation

protocol CustomerRepositoryService {
    func createCustomer(with name: String) throws
    func getLocalCustomers() -> [Customer]
    func serverSyncing() async throws
}

struct CustomerRepository: CustomerRepositoryService {
    let local: DatabaseManagerService
    let remote: CustomerAPIClientService
}

// MARK: - Synchronizations

extension CustomerRepository: Synchronizable {

    func serverSyncing() async throws {
        let serverCustomers: [Customer] = try await getRemoteCustomers()
        let localCustomers = getLocalCustomers()
        let difference = serverCustomers.difference(from: localCustomers)

        difference.forEach { change in
            switch change {
                case let .remove(_, oldElement, _):
                    deleteCustomer(oldElement)
                case let .insert(_, newElement, _):
                    createCustomer(with: newElement)
            }
        }
    }

    func notifySynced() {
        EMEventCenter.shared.post.appDataSynced()
    }

}

// MARK: - Local CRUD

extension CustomerRepository {

    func getLocalCustomers() -> [Customer] {
        local.getCustomers()
    }

    func createCustomer(with name: String) throws {
        local.addCustomer(.init(name: try .init(name)))
    }

    func createCustomer(with customer: Customer) {
        local.addCustomer(customer)
    }

    func deleteCustomer(_ customer: Customer) {
        local.deleteCustomer(customer)
    }

}

// MARK: - Remote CRUD

extension CustomerRepository {

    func getRemoteCustomers() async throws -> [Customer] {
        try await remote.getCustomers()
    }

}