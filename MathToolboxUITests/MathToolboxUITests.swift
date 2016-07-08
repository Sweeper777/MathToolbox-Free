//
//  MathToolboxUITests.swift
//  MathToolboxUITests
//
//  Created by Mulang Su on 1/2/16.
//  Copyright © 2016 Mulang Su. All rights reserved.
//

import XCTest

class MathToolboxUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
        
        let app = XCUIApplication()
        
        let tablesQuery = app.tables
        tablesQuery.elementBoundByIndex(0).swipeUp()
        tablesQuery.cells.elementBoundByIndex(tablesQuery.cells.count - 1).tap()
        
        app.navigationBars.elementBoundByIndex(0).buttons.elementBoundByIndex(3).tap()
        
        let textField = tablesQuery.textFields.elementBoundByIndex(0)
        textField.tap()
        textField.typeText("Snell's Law\r")
        
        let staticText = tablesQuery.cells.elementBoundByIndex(2)
        staticText.tap()
        staticText.tap()
        staticText.tap()
        tablesQuery.cells.elementBoundByIndex(6)
        
        let staticText2 = tablesQuery.cells.elementBoundByIndex(6)
        staticText2.tap()
        
        let cell = tablesQuery.childrenMatchingType(.Cell).elementBoundByIndex(3)
        let textField2 = cell.textFields.elementBoundByIndex(0)
        textField2.tap()
        textField2.typeText("n1\r")
        
        let textField3 = cell.textFields.elementBoundByIndex(1)
        textField3.tap()
        textField3.typeText("refractive index of the first medium")
        
        let cell2 = tablesQuery.childrenMatchingType(.Cell).elementBoundByIndex(4)
        let textField4 = cell2.textFields.elementBoundByIndex(0)
        textField4.tap()
        textField4.typeText("n2")
        
        let textField5 = cell2.textFields.elementBoundByIndex(1)
        textField5.tap()
        textField5.typeText("refractive index of the second medium")
        
        let cell3 = tablesQuery.childrenMatchingType(.Cell).elementBoundByIndex(5)
        let textField6 = cell3.textFields.elementBoundByIndex(0)
        textField6.tap()
        textField6.typeText("θi")
        
        let textField8 = cell3.textFields.elementBoundByIndex(1)
        textField8.tap()
        textField8.typeText("angle of incidence")
        
        let cell4 = tablesQuery.cells.elementBoundByIndex(7)
        
        let textField10 = cell4.textFields.elementBoundByIndex(0)
        textField10.tap()
        textField10.typeText("angle of refraction")
        
        let textField11 = cell4.textFields.elementBoundByIndex(1)
        textField11.tap()
        textField11.typeText("asin('n1' * sin('θi') / 'n2')\r")
    }
}