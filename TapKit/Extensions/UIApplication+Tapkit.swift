//
//  UIApplication+Tapkit.swift
//  TapKit
//
//  Created by Rob Caraway on 10/23/19.
//  Copyright © 2019 Rob Caraway. All rights reserved.
//

import UIKit

extension UIApplication {
    
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        print("✅ TapFunnels: 👷‍♂️ topViewController() began")
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }

        if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController

            if let top = moreNavigationController.topViewController, top.view.window != nil {
                return topViewController(base: top)
            } else if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }

        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        print("✅ TapFunnels: 👷‍♂️ topViewController() returning base controller: \(String(describing: base))")
        return base
    }
}
