//
//  TestAppUITests.swift
//  TestAppUITests
//
//  Created by Jimmie Wright on 12/15/20.
//  Copyright © 2020 finicity. All rights reserved.
//

import XCTest

class TestAppUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        if let connectUrl = ProcessInfo.processInfo.environment["CONNECT_URL"], connectUrl.count > 0 {
            generatedUrl = connectUrl
        }

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // Following Url Expires Fri Mar 05 2021 15:34:38 GMT-0700 (Mountain Standard Time)
    var generatedUrl = "https://connect2.finicity.com/?consumerId=274552dfe090bccf5ce3e735d4ef51eb&customerId=1017865679&partnerId=2445582695152&signature=deadd0a331a90753dcd91d7da407d03ae5489b7784200a4ebded572da01ab608&timestamp=1612391678803&ttl=1614983678803&webhook=https%3A%2F%2Fwebhook.site%2F9f34fa76-f542-4785-a35c-fd4d2d57b1d2"
    
    let badExpiredUrl = "https://connect2.finicity.com?consumerId=dbceec20d8b97174e6aed204856f5a55&customerId=1016927519&partnerId=2445582695152&redirectUri=http%3A%2F%2Flocalhost%3A3001%2Fcustomers%2FredirectHandler&signature=abb1762e5c640f02823c56332daede3fe2f2143f4f5b8be6ec178ac72d7dbc5a&timestamp=1607806595887&ttl=1607813795887"
    
    /*
    func test00VerifySetup() {
        // For now tester needs to manually generate a Connect 2.0 URL before running tests.
        // Set the variable above generateUrl to your generated URL.
        if generatedUrl == "" {
            XCTFail("Please use Postman to generate a Connect 2.0 URL, set generateUrl variable to value, and re-run tests.")
        }
    }
    */

    func test01BadUrl() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Steps:
        // 1. Fill in textfield with bad/expired URL
        // 2. Tap Connect Button to launch WKWebView
        // 3. Assert Exit button exists
        // 4. Tap Exit button
        
        app.textFields[AccessiblityIdentifer.UrlTextField.rawValue].typeText(badExpiredUrl)
        app.buttons[AccessiblityIdentifer.ConnectButton.rawValue].tap()
        // Wait 5 seconds for WebView with Exit button
        XCTAssert(app.webViews.webViews.webViews.buttons["Exit"].waitForExistence(timeout: 5))
        app.webViews.webViews.webViews.buttons["Exit"].tap()
    }
    
    func test02UseLegacyLoadFn() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-useLegacyLoadFn"]
        app.launch()
        
        app.textFields[AccessiblityIdentifer.UrlTextField.rawValue].typeText(badExpiredUrl)
        app.buttons[AccessiblityIdentifer.ConnectButton.rawValue].tap()
        // Wait 5 seconds for WebView with Exit button
        XCTAssert(app.webViews.webViews.webViews.buttons["Exit"].waitForExistence(timeout: 5))
        app.webViews.webViews.webViews.buttons["Exit"].tap()

    }
    
    func test03GoodUrlCancel() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        // Steps:
        // 1. Fill in textfield with good URL
        // 2. Tap Connect Button to launch WKWebView
        // 3. Assert Exit button exists
        // 4. Tap Exit button
        // 5. Assert Yes button exists
        // 6. Tap Yes button
        
        app.textFields[AccessiblityIdentifer.UrlTextField.rawValue].typeText(generatedUrl)
        app.buttons[AccessiblityIdentifer.ConnectButton.rawValue].tap()
        
        // Wait 5 seconds for WebView with Exit button
        let webViewsQuery = app.webViews.webViews.webViews
        XCTAssert(webViewsQuery.buttons["Exit "].waitForExistence(timeout: 5))
        webViewsQuery.buttons["Exit "].tap()
        // Wait 5 seconds for WebView with Yes button
        XCTAssert(webViewsQuery.buttons["Yes"].waitForExistence(timeout: 5))
        webViewsQuery.buttons["Yes"].tap()
    }
    
    func test04AddBankAccount() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        app.textFields[AccessiblityIdentifer.UrlTextField.rawValue].typeText(generatedUrl)
        app.buttons[AccessiblityIdentifer.ConnectButton.rawValue].tap()

        let webViewsQuery = app.webViews.webViews.webViews
        XCTAssert(webViewsQuery.textFields["Search for your bank"].waitForExistence(timeout: 10))
        webViewsQuery.textFields["Search for your bank"].tap()
        webViewsQuery.textFields["Search for your bank"].typeText("finbank")
        XCTAssert(webViewsQuery.staticTexts["FinBank"].waitForExistence(timeout: 5))
        webViewsQuery.staticTexts["FinBank"].tap()
        XCTAssert(webViewsQuery.buttons["Next"].waitForExistence(timeout: 5))
        webViewsQuery.buttons["Next"].tap()
        XCTAssert(webViewsQuery.staticTexts["Banking Userid"].waitForExistence(timeout: 5))
        XCTAssert(webViewsQuery.staticTexts["Banking Password"].waitForExistence(timeout: 5))
        webViewsQuery.textFields["Banking Userid"].tap()
        webViewsQuery.textFields["Banking Userid"].typeText("demo")
        webViewsQuery.secureTextFields["Banking Password"].tap()
        webViewsQuery.secureTextFields["Banking Password"].typeText("go")
        webViewsQuery.buttons[" Secure sign in"].tap()
        XCTAssert(webViewsQuery.staticTexts["Eligible accounts"].waitForExistence(timeout: 15))
        webViewsQuery.otherElements["institution container"].children(matching: .other).element(boundBy: 2).switches["Account Checkbox"].tap()
        webViewsQuery.staticTexts["Savings"].swipeUp()
        XCTAssert(webViewsQuery.buttons["Save"].waitForExistence(timeout: 5))
        webViewsQuery.buttons["Save"].tap()
        XCTAssert(webViewsQuery.buttons["Submit"].waitForExistence(timeout: 5))
        webViewsQuery.buttons["Submit"].tap()
    }
    
    func test05SafariViewController() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        app.textFields[AccessiblityIdentifer.UrlTextField.rawValue].typeText(generatedUrl)
        app.buttons[AccessiblityIdentifer.ConnectButton.rawValue].tap()

        let webViewsQuery = app.webViews.webViews.webViews
        XCTAssert(webViewsQuery.textFields["Search for your bank"].waitForExistence(timeout: 5))
        webViewsQuery.textFields["Search for your bank"].tap()
        webViewsQuery.textFields["Search for your bank"].typeText("finbank")
        XCTAssert(webViewsQuery.staticTexts["FinBank"].waitForExistence(timeout: 5))
        webViewsQuery.staticTexts["FinBank"].tap()
        XCTAssert(webViewsQuery.buttons["Next"].waitForExistence(timeout: 5))
        XCTAssert(webViewsQuery.staticTexts["Privacy policy"].waitForExistence(timeout: 5))
        webViewsQuery.staticTexts["Privacy policy"].tap()
        
        let doneButton = app.buttons["Done"]
        XCTAssert(doneButton.waitForExistence(timeout: 5))
        doneButton.tap()
    }
    
    func test06WindowOpen() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        app.textFields[AccessiblityIdentifer.UrlTextField.rawValue].typeText("https://pick3pro.com/TestOpenWin.html")
        app.buttons[AccessiblityIdentifer.ConnectButton.rawValue].tap()
        
        let webViewsQuery = app.webViews.webViews.webViews
        XCTAssert(webViewsQuery.buttons["Open Window"].waitForExistence(timeout: 5))
        webViewsQuery.buttons["Open Window"].tap()
        
        let doneButton = app.buttons["Done"]
        XCTAssert(doneButton.waitForExistence(timeout: 5))
        doneButton.tap()
    }
    
}