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
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeKeyWindow(notification:)), name: UIWindow.didBecomeKeyNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func observeLayersForTapFunnels() {
        guard let window = keyWindow else { return }
        layerObservation = window.observe(\.layer) { session, change in
            print("✅ TapFunnels: 👀 observed change in key window layers")
        }
    }
    
    @objc func didChangeKeyWindow(notification: Notification) {
        print("✅ TapFunnels: ☴ didChangeKeyWindow() trigger with \(String(describing: notification.object))")
        guard let window = notification.object as? UIWindow else { return }
        keyWindow = window
        observeLayersForTapFunnels()
    }
    
}
