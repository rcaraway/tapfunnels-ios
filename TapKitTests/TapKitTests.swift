//
//  TapKitTests.swift
//  TapKitTests
//
//  Created by Rob Caraway on 6/11/19.
//  Copyright © 2019 Rob Caraway. All rights reserved.
//

import XCTest
@testable import TapKit

class TapKitTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInit() {
        let expectation = XCTestExpectation(description: "Get Views for valid Initialization")
        let request = TapKitRequest.tapKitRequest(apiKey: "b9e316a73fe5035a8b31cdd4033b03d7b9edd29755b796b38e6a78a3de92")
        let api = TapKitAPIService(request: request)
        api.beginInitialization().done { views in
            expectation.fulfill()
            }.catch { _ in
            XCTFail()
        }
        wait(for: [expectation], timeout: 10.0)
        XCTAssertTrue(true)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
