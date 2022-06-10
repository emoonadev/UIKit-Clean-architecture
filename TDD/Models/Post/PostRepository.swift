//
// Created by Mickael Belhassen on 24/03/2022.
//

import Foundation

protocol PostRepositoryService {
    func getPosts() async throws -> [Post]
}

struct PostRepository: PostRepositoryService {
    let remote: PostAPIClientService

    init(remote: PostAPIClientService) {
        self.remote = remote
    }
}

// MARK: - CRUD

extension PostRepository {

    func getPosts() async throws -> [Post] {
        try await remote.getPosts()
    }

}