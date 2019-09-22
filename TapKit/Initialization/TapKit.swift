//
//  TapKit.swift
//  TapKit
//
//  Created by Rob Caraway on 6/11/19.
//  Copyright © 2019 Rob Caraway. All rights reserved.
//

import UIKit
import AVFoundation

public class TapKit: NSObject {

    static let shared = TapKit()
    public var api: TapKitAPIService?
    var apiKey: String?
    var dataStore: ViewDataStore = ViewDataStore()
    var obs: NSKeyValueObservation?

    public override init() {}
    
    public static func initialize(apiKey: String) {
        let tapkit = TapKit.shared
        tapkit.apiKey = apiKey
        let request = TapKitRequest.tapKitInitRequest(apiKey: apiKey)
        let api = TapKitAPIService(request: request)
        shared.api = api
        api.beginInitialization { (response, error) in
            tapkit.listenToPhoneVolumeAdjustment()
            guard let views = response else { return }
            tapkit.dataStore.save(views: views)
        }
    }
    
    public static func generateViews<T: UIViewController>(for viewController: T) {
        UIAlertController.screenNamingPrompt {
            guard let name = $0.textFields?.first?.text,
                let apiKey = TapKit.shared.apiKey else { return }
            let views = viewController.getAllViews()
            let request = TapKitRequest.tapKitViewGenerationRequest(name: name, apiKey: apiKey, views: views)
            let api = TapKitAPIService(request: request)
            api.saveViews(request: request, completion: { success in
                success ?
                    UIAlertController.showScreenConfirmationPrompt() :
                    UIAlertController.showScreenFailurePrompt()
            })
        }
    }
    
    public static func applyViewChanges<T: UIViewController>(to viewController: T) {
        let uiViews = viewController.getUIViewsFromVariables()
        let views = getViews(for: viewController)
        for view in views {
            if let name = view.name,
                let uiView = uiViews[name] {
                uiView.translate(view: view)
            }
        }
    }
    
    static func getViews<T: UIViewController>(for viewController: T) -> [View] {
        return TapKit.shared.dataStore.getViews(for: viewController)
    }
    
    private func listenToPhoneVolumeAdjustment() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(true)
        } catch {
            UIAlertController.showVolumeFailurePrompt()
            return
        }
        obs = audioSession.observe(\.outputVolume) { session, change in
            guard let viewController = UIApplication.shared.keyWindow?.rootViewController else {
                return
            }
            TapKit.generateViews(for: viewController)
        }
    }
}
