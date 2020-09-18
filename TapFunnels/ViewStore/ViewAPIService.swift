//
//  ViewAPIService.swift
//  TapFunnels
//
//  Created by Rob Caraway on 9/18/20.
//  Copyright © 2020 Rob Caraway. All rights reserved.
//

import UIKit
import HappyAPIService

public struct ViewStoreResponse: Codable {
    let name: String
    let _id: String
    let backgroundColor: String
}

public class ViewAPIService: BaseAPIService {
    public func getAllViews(completion: @escaping ([ViewResponse]?) -> Void) {
        let request = URLRequest(url: URL(string: "https://tapfunnels.herokuapp.com/views")!)
        self.loadRequest(request: request, responseType: [ViewResponse].self) { (result) in
            switch result {
            case .success(let response):
                completion(response)
            case .error(_):
                completion(nil)
            }
        }
    }
}
