//
// Created by Mickael Belhassen on 16/03/2022.
//

import XCTest
@testable import TDD
import ViewControllerPresentationSpy

class AddCustomerViewControllerTests: XCTestCase {
    var sut: AddCustomerViewController!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = AddCustomerViewController()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testDeallocation() {
        assertDeallocation { AddCustomerViewController() }
    }
}
