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
    let viewCoordinator: ViewCoordinator

    public override init() {
        viewCoordinator = ViewCoordinator()
    }
    
    public static func initialize(apiKey: String) {
        print("✅ TapFunnels: 🎬 Initialize() began")
        let tapkit = TapKit.shared
        tapkit.apiKey = apiKey
        let request = TapKitRequest.tapKitInitRequest(apiKey: apiKey)
        let api = TapKitAPIService(request: request)
        shared.api = api
        api.beginInitialization { (response, error) in
            tapkit.listenToPhoneVolumeAdjustment()
            guard let views = response else {
                print("✅ TapFunnels: 🎬 Initialize() FAILED with error: \(String(describing: error))")
                return
            }
            print("✅ TapFunnels: 🎬 Initialize() returned views: \(views)")
            tapkit.dataStore.save(views: views)
        }
    }
    
    public static func generateViews<T: UIViewController>(for viewController: T) {
        print("✅ TapFunnels: 👩‍🎨 generateViews() began for \(viewController)")
        UIAlertController.screenNamingPrompt {
            guard let name = $0.textFields?.first?.text,
                let apiKey = TapKit.shared.apiKey else { return }
            print("✅ TapFunnels: 👩‍🎨 generateViews() picked name: \(name) for \(viewController)")
            let views = viewController.getAllViews()
            let request = TapKitRequest.tapKitViewGenerationRequest(name: name, apiKey: apiKey, views: views)
            let api = TapKitAPIService(request: request)
            api.saveViews(request: request, completion: { success in
                if success {
                    UIAlertController.showScreenConfirmationPrompt()
                    print("✅ TapFunnels: 👩‍🎨 generateViews() success!")
                }else {
                    print("✅ TapFunnels: 👩‍🎨 generateViews() FAILED!")
                    UIAlertController.showScreenFailurePrompt()
                }
            })
        }
    }
    
    public static func applyViewChanges<T: UIViewController>(to viewController: T) {
        print("✅ TapFunnels: 👑 applyViewChanges() began to view Controller \(viewController)")
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
            print("✅ TapFunnels: 🔈 VOLUMNE CHANGED()")
            guard let viewController = UIApplication.topViewController() else {
                return
            }
            TapKit.generateViews(for: viewController)
        }
        print("✅ TapFunnels: 🔈 LISTENING TO VOLUME with observer \(obs)")
    }
    
    
}
