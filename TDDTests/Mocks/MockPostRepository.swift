//
// Created by Mickael Belhassen on 24/03/2022.
//

import Foundation
@testable import TDD

class MockPostRepository: PostRepositoryService {

    var posts = [Post]()

    func getPosts() async throws -> [Post] {
        posts
    }

}
