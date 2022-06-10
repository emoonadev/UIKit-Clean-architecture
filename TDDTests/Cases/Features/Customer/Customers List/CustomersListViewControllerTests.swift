//
//  CustomersListViewControllerTests.swift
//  TDDTests
//
//  Created by Mickael Belhassen on 17/03/2022.
//

import XCTest
import ViewControllerPresentationSpy
@testable import TDD

class CustomersListViewControllerTests: XCTestCase {

    var sut: CustomersListViewController!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = CustomersListViewController()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

}
