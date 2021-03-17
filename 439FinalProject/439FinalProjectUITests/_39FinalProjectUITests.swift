//
//  _39FinalProjectUITests.swift
//  439FinalProjectUITests
//
//  Created by Anamika Basu on 3/16/21.
//

import XCTest

class _39FinalProjectUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testCreateHikeUI() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["Login"].tap()
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        let datePickersQuery2 = elementsQuery.datePickers
        datePickersQuery2.collectionViews.buttons["Thursday, March 18"].otherElements.containing(.staticText, identifier:"18").element.tap()
        
        let datePickersQuery = datePickersQuery2
        datePickersQuery/*@START_MENU_TOKEN@*/.buttons["PM"]/*[[".otherElements[\"Time Picker\"]",".segmentedControls.buttons[\"PM\"]",".buttons[\"PM\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        datePickersQuery/*@START_MENU_TOKEN@*/.buttons["AM"]/*[[".otherElements[\"Time Picker\"]",".segmentedControls.buttons[\"AM\"]",".buttons[\"AM\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let hoursElement = datePickersQuery/*@START_MENU_TOKEN@*/.otherElements["Hours"]/*[[".otherElements[\"Time Picker\"]",".otherElements[\"Time\"].otherElements[\"Hours\"]",".otherElements[\"Hours\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        hoursElement.tap()
        hoursElement.swipeUp()
        
        let dateTimeElement = scrollViewsQuery.otherElements.containing(.staticText, identifier:"Date & Time").element
        dateTimeElement.swipeUp()
        elementsQuery.textFields["Enter preferred group size"].tap()
        dateTimeElement.swipeUp()
        scrollViewsQuery.otherElements.containing(.staticText, identifier:"Date & Time").children(matching: .textView).element.tap()
        elementsQuery.buttons["Post Hike"].tap()
        
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
