//
//  TapKitAPIService.swift
//  TapKit
//
//  Created by Rob Caraway on 6/11/19.
//  Copyright © 2019 Rob Caraway. All rights reserved.
//

import UIKit
import PromiseKit

struct ViewResponse: Codable {
    let name: String
    let colorRed: Int
    let colorBlue: Int
    let colorGreen: Int
}

private struct APIResponse: Codable {
    let success: Bool
    let status: Int
    let message: String
    let views: [ViewResponse]
}

public class TapKitAPIService {
    
    let request: TapKitRequest
    private(set) var busy = false
    
    // @REQUIRE:  must be a valid SeatGeek API URL
    init(request: TapKitRequest) {
        guard request.isValidTapKitRequest() else {
            fatalError("valid URL Required")
        }
        self.request = request
    }
    
    //TODO: Return View Objects
    func beginInitialization() -> Promise<[ViewResponse]> {
        return Promise<[ViewResponse]>() { promise in
            DispatchQueue.global().async {
                let task = URLSession.shared.dataTask(with: self.request) { (data, response, error) in
                    print("👀 SUCCESS? \(String(describing: data))")
                    guard let data = data,
                        let apiResponse = try? JSONDecoder().decode(APIResponse.self, from: data) else {
                            promise.reject(error!); return
                    }
                    promise.fulfill(apiResponse.views)
                }
            }
        }
    }
    
}
