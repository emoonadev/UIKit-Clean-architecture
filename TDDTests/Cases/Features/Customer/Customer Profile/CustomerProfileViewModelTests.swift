//
// Created by Mickael Belhassen on 24/03/2022.
//

import XCTest
@testable import TDD

class CustomerProfileViewModelTests: XCTestCase {

    var sut: CustomerProfileViewModel!
    var postRepository: MockPostRepository { sut.postRepository as! MockPostRepository }

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = CustomerProfileViewModel(postRepository: MockPostRepository())
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

}