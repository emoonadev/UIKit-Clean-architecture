//
//  CustomersListViewControllerUITests.swift
//  TDDUITests
//
//  Created by Mickael Belhassen on 22/03/2022.
//

import XCTest

class CustomersListViewControllerUITests: XCTestCase {
    
    var app: XCUIApplication!
    

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testMytest() {
        app.navigationBars["TDD.CustomersListView"].buttons["Add"].tap()
        app.windows.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.swipeDown()
        
    }
}

