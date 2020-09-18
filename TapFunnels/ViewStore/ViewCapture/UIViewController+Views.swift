//
//  UIController+Views.swift
//  
//
//  Created by Rob Caraway on 8/16/20.
//
#if !os(macOS)
import UIKit

public extension UIViewController {
    
    func takeSnapshotOfViews(_ reflect: Mirror? = nil) -> [String : UIView] {
        var views = [String : [UIView]]()
        
        forEachView { (name, view) in
            if var vws = views[name] {
                let doesntExist = vws.filter {
                    let exists = ($0 === view)
                    return exists
                }.count == 0
                if doesntExist {
                    vws.append(view)
                    views[name] = vws
                }
            }else {
                views[name] = [view]
            }
        }
        var finalViews = [String: UIView]()
        for key in views.keys {
            //check if its close
            guard var vws = views[key] else { continue }
            if vws.count > 1 {
                vws.sort { (first, second) -> Bool in
                    return  first.frame.minX < second.frame.minX || (first.frame.minX == second.frame.minX && first.frame.minY < second.frame.minY)
                }
                for (index, val) in vws.enumerated() {
                    finalViews["\(key)\(index + 1)"] = val
                }
            } else {
                finalViews[key] = vws.first
            }
        }
        return finalViews
    }
    
    func getViewStores() -> [ViewStore] {
        var views = [ViewStore]()
        let uiViews = takeSnapshotOfViews()
        uiViews.forEach { key, value in
            let viewStore = ViewStore(name: key, frame: value.frame, backgroundColor: view.backgroundColor?.hexString() ?? UIColor.clear.hexString())
            views.append(viewStore)
        }
        return views
    }
    
    func layoutViews(from stores: [ViewStore]) {
        let views = takeSnapshotOfViews()
        for store in stores {
            if let view = views[store.name] {
                view.backgroundColor = UIColor(hex: store.backgroundColor) ?? view.backgroundColor
                view.frame = store.frame ?? view.frame
            }
        }
    }
    
    private func forEachView(_ reflect: Mirror? = nil, viewBlock:(String, UIView) -> Void) {
        if let nav = self as? UINavigationController,
            let top = nav.topViewController {
            let navMirror = Mirror(reflecting: top)
            top.forEachView(navMirror, viewBlock: viewBlock)
        }
        if let tab = self as? UITabBarController,
            let current = tab.selectedViewController {
            let tabMirror = Mirror(reflecting: current)
            current.forEachView(tabMirror, viewBlock: viewBlock)
        }
        if let presented = self.presentedViewController {
            let presentedMirror = Mirror(reflecting: presented)
            presented.forEachView(presentedMirror, viewBlock: viewBlock)
        }
        let mirror = reflect ?? Mirror(reflecting: self)
        if mirror.superclassMirror != nil {
            self.forEachView(mirror.superclassMirror, viewBlock: viewBlock)
        }
        for (_, attribute) in mirror.children.enumerated() {
            if let propertyName = attribute.label {
                if let viewController = attribute.value as? UIViewController {
                    viewController.forEachView(viewBlock: viewBlock)
                }
                if let uiView = attribute.value as? UIView {
                    var name = "\(NSStringFromClass(type(of: self))).\(propertyName)"
                    let components = name.components(separatedBy: ".")
                    if components.count > 2 {
                        name = "\(components[components.count - 2]).\(components[components.count - 1])"
                    }
                    viewBlock(name, uiView)
                }
            }
        }
    }
}
#endif
