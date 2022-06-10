//
// Created by Mickael Belhassen on 27/03/2022.
//

import XCTest
@testable import TDD

class NameTests: XCTestCase {

    var sut: Name!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = Name(rawValue: "Test")
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

}

// MARK: - init

extension NameTests {

    func testInitThrowWhenEnterValidName() throws {
        XCTAssertNoThrow(try Name("Mickael"))
    }

    func testInitThrowWhenEnterEmptyName() throws {
        XCTAssertThrowsError(try Name(""))
    }

    func testInitWhenEnterValidName() throws {
        XCTAssertNotNil(try Name(rawValue: "Mickael"))
    }

    func testInitWhenEnterEmptyName() throws {
        XCTAssertNil(try Name(rawValue: ""))
    }

}
