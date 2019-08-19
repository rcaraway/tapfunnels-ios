//
//  TapKit.swift
//  TapKit
//
//  Created by Rob Caraway on 6/11/19.
//  Copyright © 2019 Rob Caraway. All rights reserved.
//

import UIKit

public class TapKit: NSObject {

    static let shared = TapKit()
    public var api: TapKitAPIService?
    var apiKey: String?
    var dataStore: ViewDataStore = ViewDataStore()
    
    public override init() {}
    
    public static func initialize(apiKey: String) {
        let tapkit = TapKit.shared
        tapkit.apiKey = apiKey
        let request = TapKitRequest.tapKitInitRequest(apiKey: apiKey)
        let api = TapKitAPIService(request: request)
        shared.api = api
        api.beginInitialization { (response, error) in
            guard let views = response else { return }
            tapkit.dataStore.save(views: views)
        }
    }
    
    public static func generateViews<T: UIViewController>(for viewController: T) {
        // prompt user to input a name
        let alertController = UIAlertController(title: "Name the screen", message: "", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { textField in
            textField.placeholder = "Screen Name"
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            alertController.presentingViewController?.dismiss(animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { action in
            alertController.presentingViewController?.dismiss(animated: true, completion: nil)
            guard let name = alertController.textFields?.first?.text,
                let apiKey = TapKit.shared.apiKey else { return }
            let views = viewController.getViewResponsesFromVariables()
            let request = TapKitRequest.tapKitViewGenerationRequest(name: name, apiKey: apiKey, views: views)
            
            let api = TapKitAPIService(request: request)
            api.saveViews(request: request, completion: { success in
                
                //show success alert
                //OR
                //show failure alert
            })
        }))
        guard let rootController = viewController.view.window?.rootViewController else { return }
        rootController.present(alertController, animated: true, completion: nil)
    }
    
    public static func applyViewChanges<T: UIViewController>(to viewController: T) {
        let views = getViews(for: viewController)
        //for each view with same name
        //apply any updates to it
    }
    
    static func getViews<T: UIViewController>(for viewController: T) -> [View] {
        
    }
}
