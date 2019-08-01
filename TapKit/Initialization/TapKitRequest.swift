//
//  TapKitRequest.swift
//  TapKit
//
//  Created by Rob Caraway on 6/11/19.
//  Copyright © 2019 Rob Caraway. All rights reserved.
//

import Foundation

public typealias TapKitRequest = URLRequest

public extension URLRequest {
    
    private static let IS_HALCYON = false
    private static let TAPKIT_HOST = "localhost.com"
    private static var TAPKIT_DEVELOPER_HOST: String {
        return IS_HALCYON ?  "10.10.10.33" : "192.168.0.20"
    }
    private static let TAPKIT_PORT = 9001
    private static let TAPKIT_SCHEME = "http"
    
    private static let TAPKIT_INIT_PATH = "/api/user/initialize"
    private static let TAPKIT_GENERATE_SCREEN = "/api/app/screen/generate"

    static func tapKitRequest(apiKey:String) -> TapKitRequest {
        var components = URLComponents()
        components.scheme = TAPKIT_SCHEME
        components.host = TAPKIT_DEVELOPER_HOST
        components.path = TAPKIT_INIT_PATH
        components.port = TAPKIT_PORT
        guard let url = components.url,
            let uniqueId = UIDevice.current.identifierForVendor?.uuidString else {
            fatalError("Request must work")
        }
        var request = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 10)
        request.setValue(apiKey, forHTTPHeaderField:"AppToken")
        request.setValue(uniqueId, forHTTPHeaderField: "AppUserId")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        print("✅ AppToken: \(String(describing: apiKey))")
        print("✅ PhoneID: \(String(describing: uniqueId))")
        print("✅ URL: \(String(describing: request.url))")
        return request
    }
    
    static func tapKitViewGenerationRequest(apiKey: String, views: [ViewResponse]) {
        
    }
    
    func isValidTapKitRequest() -> Bool {
        return url?.host == URLRequest.TAPKIT_DEVELOPER_HOST &&
            url?.scheme == URLRequest.TAPKIT_SCHEME
    }

}

