//
//  TapFunnelsViewController.swift
//  TapKit
//
//  Created by Rob Caraway on 11/1/19.
//  Copyright © 2019 Rob Caraway. All rights reserved.
//

import UIKit


// observe windows layers subviews.
// observe rootviewcontroller subviews
public class ViewCoordinator {
    
    var layerObservation: NSKeyValueObservation?
    weak var keyWindow: UIWindow?

    init() {
        if let window = UIApplication.shared.delegate?.window  {
            keyWindow = window
            observeLayersForTapFunnels()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeKeyWindow(notification:)), name: UIWindow.didBecomeKeyNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func observeLayersForTapFunnels() {
        guard let window = keyWindow else { return }
        print("✅ TapFunnels: 👀  observeLayersForTapFunnels called")
        layerObservation = window.layer.observe(\.sublayers) { session, change in
            
            print("✅ TapFunnels: 👀 observed change in key window layers \(String(describing: window.rootViewController?.view.subviews))")
        }
    }
    
    @objc func didChangeKeyWindow(notification: Notification) {
        print("✅ TapFunnels: ☴ didChangeKeyWindow() trigger with \(String(describing: notification.object))")
        
        guard let window = UIApplication.shared.delegate?.window else { return }
        keyWindow = window
        observeLayersForTapFunnels()
    }
    
}
