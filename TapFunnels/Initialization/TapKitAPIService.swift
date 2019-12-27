//
//  TapKitAPIService.swift
//  TapKit
//
//  Created by Rob Caraway on 6/11/19.
//  Copyright © 2019 Rob Caraway. All rights reserved.
//

import UIKit

private struct ApiInitResponse: Decodable {
    let success: Bool
    let status: Int
    let message: String
    let views: [ViewResponse]
}

private struct ApiGenerateResponse: Decodable {
    let success: Bool
    let status: Int
    let message: String
}

public class TapKitAPIService {
    
    let request: TapKitRequest
    private(set) var busy = false
    
    // @REQUIRE:  must be a valid Tapkit API URL
    init(request: TapKitRequest) {
        guard request.isValidTapKitRequest() else {
            fatalError("valid URL Required")
        }
        self.request = request
    }
    
    func beginInitialization(completion: @escaping ([ViewResponse]?,Error?) -> Void) {
        print("✅ TapFunnels: ✈ API: beginInitialization() began")
        DispatchQueue.global().async {
            let task = URLSession.shared.dataTask(with: self.request) { (data, response, error) in
                guard let data = data,
                let apiResponse = try? JSONDecoder().decode(ApiInitResponse.self, from: data)
                    else {
                        DispatchQueue.main.async {
                            print("✅ TapFunnels: ✈ API: beginInitialization() FAILED with response:\(String(describing: response)) \nerror: \(String(describing: error))")
                            completion(nil, error)
                        }
                        return
                }
                DispatchQueue.main.async {
                    print("✅ TapFunnels: ✈ API: beginInitialization() succeeded with response: \(apiResponse)")
                    completion(apiResponse.views, nil)
                }
            }
            task.resume()
        }
    }
    
    func saveViews(request: TapKitRequest, completion: @escaping (Bool) -> Void) {
        print("✅ TapFunnels: ✈ API: saveViews() began")
        DispatchQueue.global().async {
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data,
                    let message = try? JSONDecoder().decode(ApiGenerateResponse.self, from: data) else {
                        DispatchQueue.main.async {
                            print("✅ TapFunnels: ✈ API: saveViews() FAILED with error: \(String(describing: error))")
                            completion(false)
                        }
                        return
                }
                DispatchQueue.main.async {
                    print("✅ TapFunnels: ✈ API: saveViews() success with status \(message.status)")
                    completion(message.status == 200)
                }
            }
            task.resume()
        }
        
    }
    
    func generateViews(apiKey: String, from viewController: UIViewController, completion: @escaping ([ViewResponse]?) -> Void) {
        generateViews(screenName: nil, apiKey: apiKey, from: viewController, completion: completion)
    }
        
    func generateViews(screenName: String?,
                       apiKey: String,
                       from viewController: UIViewController,
                       completion: @escaping ([ViewResponse]?) -> Void) {
        print("✅ TapFunnels: ✈ API: generateViews() began with name: \(String(describing: screenName)) \nViewController: \(viewController)")
        DispatchQueue.global().async {
            let views = viewController.getAllViews()
            let viewRequest = TapKitRequest.tapKitViewGenerationRequest(name:screenName, apiKey: apiKey, views: views)
            let task = URLSession.shared.dataTask(with: viewRequest) { (data, response, error) in
                guard let data = data,
                    let _ = try? JSONDecoder().decode(ApiGenerateResponse.self, from: data) else {
                        DispatchQueue.main.async {
                            print("✅ TapFunnels: ✈ API: generateViews() FAILED with error \(String(describing: error))")
                            completion(nil)
                        }
                        return
                }
                DispatchQueue.main.async {
                    print("✅ TapFunnels: ✈ API: generateViews() success with views \(views)")
                    completion(views)
                }
            }
            task.resume()
        }
    }
}
