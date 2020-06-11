//
//  OneRMUITests.swift
//  OneRMUITests
//
//  Created by Oliver Lau on 10.06.20.
//  Copyright © 2020 Oliver Lau. All rights reserved.
//

import XCTest

class OneRMUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        setupSnapshot(app)
    }
    
    func testForSnapshots() throws {
        app.launch()

        snapshot("MainViewController")

        let menuButton = app.navigationBars["One-RM"].buttons["Menu"]
        menuButton.tap()

        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Lift log"]/*[[".cells.staticTexts[\"Lift log\"]",".staticTexts[\"Lift log\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        snapshot("LogViewController-Before")

        let liftLogNavigationBar = app.navigationBars["Lift log"]
        liftLogNavigationBar.buttons["One-RM"].tap()
        menuButton.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Settings"]/*[[".cells.staticTexts[\"Settings\"]",".staticTexts[\"Settings\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        snapshot("SettingsViewController")
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Exercises"]/*[[".cells.staticTexts[\"Exercises\"]",".staticTexts[\"Exercises\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        snapshot("ExercisesTableViewController")

        app.navigationBars["Exercises"].buttons["back"].tap()
        app.navigationBars["Settings"].buttons["One-RM"].tap()
        app.navigationBars["One-RM"].buttons["Log lift"].tap()

        snapshot("SaveToLogViewController")

        app.navigationBars["OneRM.SaveToLogView"].buttons["Save"].tap()
        snapshot("LogViewController-After")

    }
    
}
