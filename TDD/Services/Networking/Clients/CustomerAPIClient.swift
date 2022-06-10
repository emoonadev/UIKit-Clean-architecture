//
// Created by Mickael Belhassen on 05/05/2022.
//

import Foundation

protocol CustomerAPIClientService {
    func getCustomers() async throws -> [Customer]
}

final class CustomerAPIClient: CustomerAPIClientService {
    let apiClient: APIService

    init(apiClient: APIService) {
        self.apiClient = apiClient
    }
}

// MARK: - CRUD

extension CustomerAPIClient {

    func getCustomers() async throws -> [Customer] {
        try await apiClient.perform(.getCustomers)
    }

}
