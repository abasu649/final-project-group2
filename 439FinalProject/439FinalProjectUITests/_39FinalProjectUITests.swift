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
//        let dateTimeLabel = app.staticTexts["Date and Time Label"]
//        let inviteFriendsLabel = app.staticTexts["Invite Friends Label"]
//        let visibilityLabel = app.staticTexts["Visibility Label"]
//        let groupSizeLabel = app.staticTexts["Group Size Label"]
//        let miscLabel = app.staticTexts["Misc. Label"]
//        let friendsListButton = app.buttons["Open Friends List Button"]
//        let postHikeButton = app.buttons["Post Hike Button"]
//        let visibilitySlider = app.sliders["Public Slider"]
//        let groupSize = app.textFields["Group Size Text Field"]
//        let details = app.textViews["Misc. Text View"]
//        XCTAssert(inviteFriendsLabel.exists)
//        XCTAssert(dateTimeLabel.exists)
//        XCTAssert(visibilityLabel.exists)
//        XCTAssert(groupSizeLabel.exists)
//        XCTAssert(miscLabel.exists)
//        XCTAssert(friendsListButton.exists)
//        XCTAssert(postHikeButton.exists)
//        XCTAssert(visibilitySlider.exists)
//        XCTAssert(groupSize.exists)
//        XCTAssert(details.exists)
        
        app.buttons["Login"].tap()
        
        let scrollViewsQuery = app.scrollViews
        scrollViewsQuery.otherElements.buttons["Open Friends List"].tap()
        scrollViewsQuery.otherElements.containing(.staticText, identifier:"Date & Time").element.swipeUp()
        
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
