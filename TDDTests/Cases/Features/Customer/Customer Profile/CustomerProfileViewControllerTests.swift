//
// Created by Mickael Belhassen on 24/03/2022.
//

import XCTest
@testable import TDD

class CustomerProfileViewControllerTests: XCTestCase {

    var sut: CustomerProfileViewController!


    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = CustomerProfileViewController()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

}