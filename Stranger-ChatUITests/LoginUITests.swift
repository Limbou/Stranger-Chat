//
//  LoginUITests.swift
//  Stranger-ChatTests
//
//  Created by Jakub Danielczyk on 03/06/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import XCTest

class LoginUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {
        app = nil
    }

    func testExample() {
        app.buttons["Offline Mode"].tap()
        app.textFields["nickname"].tap()
        app.buttons["Login"].tap()
    }

}
