//
//  TapKitAPIService.swift
//  TapKit
//
//  Created by Rob Caraway on 6/11/19.
//  Copyright © 2019 Rob Caraway. All rights reserved.
//

import UIKit

private struct APIResponse: Decodable {
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
    func beginInitialization(completion: @escaping ([ViewResponse]?,Error?) -> Void) {
        DispatchQueue.global().async {
            let task = URLSession.shared.dataTask(with: self.request) { (data, response, error) in
                print("👀 SUCCESS? \(String(describing: data))")
                guard let data = data,
                    let apiResponse = try? JSONDecoder().decode(APIResponse.self, from: data) else {
                        DispatchQueue.main.async {
                            completion(nil, error)
                        }
                        return
                }
                DispatchQueue.main.async {
                    completion(apiResponse.views, nil)
                }
            }
            task.resume()
        }
    }
    
    func generateViews(from viewController: UIViewController, completion: @escaping (/*TODO: FILL THIS OUT */) -> Void) {
        //TODO: finish translating from psuedocode
        //get all views and superviews within the view controller
        //make sure they all have names
    }
    
}
