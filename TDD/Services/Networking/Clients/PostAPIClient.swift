//
// Created by Mickael Belhassen on 05/05/2022.
//

import Foundation

protocol PostAPIClientService {
    func getPosts() async throws -> [Post]
}

final class PostAPIClient: PostAPIClientService {
    let apiClient: APIService

    init(apiClient: APIService) {
        self.apiClient = apiClient
    }
}

// MARK: - CRUD

extension PostAPIClient {

    func getPosts() async throws -> [Post] {
        try await apiClient.perform(.getPosts)
    }

}
