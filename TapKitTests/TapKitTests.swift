//
//  TapKitTests.swift
//  TapKitTests
//
//  Created by Rob Caraway on 6/11/19.
//  Copyright © 2019 Rob Caraway. All rights reserved.
//

import XCTest
@testable import TapKit

class FakeController: UIViewController {
    var fakeButton: UIButton = UIButton()
    var fakeLabel: UILabel = UILabel()
}

class TapKitTests: XCTestCase {
    func testInit() {
        let expectation = XCTestExpectation(description: "Get Views for valid Initialization")
        let request = TapKitRequest.tapKitRequest(apiKey: "b9e316a73fe5035a8b31cdd4033b03d7b9edd29755b796b38e6a78a3de92")
        let api = TapKitAPIService(request: request)
        api.beginInitialization { (response , error) in
            if error != nil {
                XCTFail()
            }else {
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 10.0)
        XCTAssertTrue(true)
    }
}
