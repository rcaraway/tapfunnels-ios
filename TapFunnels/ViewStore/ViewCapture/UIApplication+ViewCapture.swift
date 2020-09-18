//
//  File.swift
//  
//
//  Created by Rob Caraway on 8/16/20.
//
#if !os(macOS)
import UIKit

public extension UIApplication {
    
    class func takeSnapshotOfViews() -> [String : UIView]? {
        UIApplication.shared.keyWindow?.rootViewController?.takeSnapshotOfViews()
    }
    
    class func getViewStores() -> [ViewStore]? {
        UIApplication.shared.keyWindow?.rootViewController?.getViewStores()
    }
    
    class func layoutViews(from stores: [ViewStore]) {
        UIApplication.shared.keyWindow?.rootViewController?.layoutViews(from: stores)
    }
} 
#endif
