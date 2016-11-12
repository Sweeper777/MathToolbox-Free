import XCTest

class MathToolboxUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        setupSnapshot(XCUIApplication())
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
        
        let app = XCUIApplication()
        
        snapshot("1")
        
        let tablesQuery = app.tables
        tablesQuery.element(boundBy: 0).swipeUp()
        tablesQuery.cells.element(boundBy: tablesQuery.cells.count - 1).tap()
        
        app.navigationBars.element(boundBy: 0).buttons.element(boundBy: 3).tap()
        
        let textField = tablesQuery.textFields.element(boundBy: 0)
        textField.tap()
        textField.typeText("Snell's Law\r")
        
        let staticText = tablesQuery.cells.element(boundBy: 2)
        staticText.tap()
        staticText.tap()
        staticText.tap()
        tablesQuery.cells.element(boundBy: 6)
        
        let staticText2 = tablesQuery.cells.element(boundBy: 6)
        staticText2.tap()
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 3)
        let textField2 = cell.textFields.element(boundBy: 0)
        textField2.tap()
        textField2.typeText("n1\r")
        
        let textField3 = cell.textFields.element(boundBy: 1)
        textField3.tap()
        textField3.typeText("refractive index of the first medium")
        
        let cell2 = tablesQuery.children(matching: .cell).element(boundBy: 4)
        let textField4 = cell2.textFields.element(boundBy: 0)
        textField4.tap()
        textField4.typeText("n2")
        
        let textField5 = cell2.textFields.element(boundBy: 1)
        textField5.tap()
        textField5.typeText("refractive index of the second medium")
        
        let cell3 = tablesQuery.children(matching: .cell).element(boundBy: 5)
        let textField6 = cell3.textFields.element(boundBy: 0)
        textField6.tap()
        textField6.typeText("θi")
        
        let textField8 = cell3.textFields.element(boundBy: 1)
        textField8.tap()
        textField8.typeText("angle of incidence")
        
        let cell4 = tablesQuery.cells.element(boundBy: 7)
        
        let textField10 = cell4.textFields.element(boundBy: 0)
        textField10.tap()
        textField10.typeText("angle of refraction")
        
        let textField11 = cell4.textFields.element(boundBy: 1)
        textField11.tap()
        textField11.typeText("asin('n1' * sin('θi') / 'n2')\r")
        
        snapshot("2")
    }
}
