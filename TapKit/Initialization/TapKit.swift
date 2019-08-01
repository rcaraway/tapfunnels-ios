//
//  TapKit.swift
//  TapKit
//
//  Created by Rob Caraway on 6/11/19.
//  Copyright © 2019 Rob Caraway. All rights reserved.
//

import UIKit

public class TapKit {

    static let shared = TapKit()
    public var api: TapKitAPIService?
    
    //Asynchronous
    static func initialize(apiKey: String) {
        let request = TapKitRequest.tapKitRequest(apiKey: apiKey)
        let api = TapKitAPIService(request: request)
        shared.api = api
        api.beginInitialization { (response, error) in
            
        }
    }
    
}
