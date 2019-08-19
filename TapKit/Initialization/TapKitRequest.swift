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

    static func tapKitInitRequest(apiKey:String) -> TapKitRequest {
        let components = tapkitBaseComponents(path: TAPKIT_INIT_PATH)
        guard let url = components.url,
            let uniqueId = UIDevice.current.identifierForVendor?.uuidString else {
            fatalError("Request must work")
        }
        var request = baseTapkitRequest(url: url, apiKey: apiKey)
        request.setValue(uniqueId, forHTTPHeaderField: "AppUserId")
        print("✅ AppToken: \(String(describing: apiKey))")
        print("✅ PhoneID: \(String(describing: uniqueId))")
        print("✅ URL: \(String(describing: request.url))")
        return request
    }
    
    static func tapKitViewGenerationRequest(name: String?,
                                            apiKey: String,
                                            views: [ViewResponse]) -> TapKitRequest {
        let components = tapkitBaseComponents(path: TAPKIT_GENERATE_SCREEN)
        guard let url = components.url,
        let body = try? JSONEncoder().encode(views) else {
            fatalError("Request must work")
        }
        var request = baseTapkitRequest(url: url, apiKey: apiKey)
        if let name = name {
            request.setValue(name, forHTTPHeaderField: "ScreenName")
        }
        request.httpBody = body
        return request
    }
    
    private static func tapkitBaseComponents(path: String = "") -> URLComponents {
        var components = URLComponents()
        components.scheme = TAPKIT_SCHEME
        components.host = TAPKIT_DEVELOPER_HOST
        components.path = path
        components.port = TAPKIT_PORT
        return components
    }
    
    private static func baseTapkitRequest(url: URL, apiKey: String) -> URLRequest {
        var request = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 10)
        request.setValue(apiKey, forHTTPHeaderField:"AppToken")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    func isValidTapKitRequest() -> Bool {
        return url?.host == URLRequest.TAPKIT_DEVELOPER_HOST &&
            url?.scheme == URLRequest.TAPKIT_SCHEME
    }

}

