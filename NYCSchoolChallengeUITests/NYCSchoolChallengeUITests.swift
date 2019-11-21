//
//  NYCSchoolChallengeUITests.swift
//  NYCSchoolChallengeUITests
//
//  Created by Hudson Mcashan on 11/21/19.
//  Copyright © 2019 Guardian Angel. All rights reserved.
//

import XCTest
@testable import NYCSchoolChallenge

class NYCSchoolChallengeUITests: XCTestCase {

    let stubs = DynamicStubs()
    
    lazy var app: XCUIApplication = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        
        app.launchArguments += ["TESTING"]
        
        try! stubs.server.start()
        
        continueAfterFailure = false
    }
    
    override func tearDown() {
        super.tearDown()
        stubs.server.stop()
    }
    
    func testViewControllerShowsPeople() {
        stubs.stubRequest(path: "/test", jsonData: StubbedData().jsonData!)
        
        app.launch()
        
        // used so you can see the results before it completes
        sleep(3)
        
        let schoolCellCount = app.tables.cells.count
        XCTAssertEqual(schoolCellCount, 6, "Number Of cells do not match stubbed data")
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
