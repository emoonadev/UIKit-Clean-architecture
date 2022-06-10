//
// Created by Mickael Belhassen on 24/03/2022.
//

import Foundation

struct CustomerProfileViewModel {
    let postRepository: PostRepositoryService
    let posts: Observable<[Post]> = Observable([])

    @Observable(nil) var customer: Customer?

    init(postRepository: PostRepositoryService) {
        self.postRepository = postRepository
    }
}

// MARK: - UI interaction

extension CustomerProfileViewModel {

    func refreshPosts() {
        Task {
            do {
                posts.value = try await postRepository.getPosts()
            } catch {

            }
        }
    }

}
