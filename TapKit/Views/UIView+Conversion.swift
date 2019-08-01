//
//  UIView+Conversion.swift
//  TapKit
//
//  Created by Rob Caraway on 7/23/19.
//  Copyright © 2019 Rob Caraway. All rights reserved.
//

import UIKit
import CoreImage

extension UIViewController {
   
    public func getAllViews() -> [ViewResponse] {
        return getViewResponsesFromVariables()
    }
    
    private func getSubviewsFor(view: UIView) -> [ViewResponse] {
        var subviews: [ViewResponse] = []
        subviews.append(getNewViewResponse(from: view))
        for subview in view.subviews {
            subviews.append(contentsOf: getSubviewsFor(view: subview))
        }
        return subviews
    }
    
    private func getNewViewResponse(from view: UIView, name: String = "") -> ViewResponse {
        let color: UIColor = view.backgroundColor ?? .clear
        return ViewResponse(name: name,
                                    colorRed:color.red(),
                                    colorBlue: color.blue(),
                                    colorGreen: color.green(),
                                    dateModified: Date())
        
    }
    
    public func getViewResponsesFromVariables(reflect: Mirror? = nil) -> [ViewResponse] {
        let mirror = reflect ?? Mirror(reflecting: self)
        var views: [ViewResponse] = []
        if mirror.superclassMirror != nil {
            views.append(contentsOf: getViewResponsesFromVariables(reflect: mirror.superclassMirror))
        }
        for (index, attribute) in mirror.children.enumerated() {
            if let propertyName = attribute.label {
                if let viewController = attribute.value as? UIViewController {
                   //FIXME: be weary of casting to UIViewController, it might not work properly
                    views.append(contentsOf: viewController.getViewResponsesFromVariables())
                }
                if let uiView = attribute.value as? UIView {
                    let name = "\(NSStringFromClass(type(of: self))).\(propertyName)"
                    views.append(getNewViewResponse(from: uiView, name: name))
                }
                print("\(mirror.description) \(index): \(propertyName) = \(attribute.value)")
            }
        }
        return views
    }
}

public extension UIView {
    func translate(view: View) {
        backgroundColor = UIColor(red: CGFloat(view.colorRed)/255.0,
                                  green:  CGFloat(view.colorGreen)/255.0,
                                  blue:  CGFloat(view.colorBlue)/255.0, alpha: 1.0)
        
    }
    
    private func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}
