//
//  UIView+Conversion.swift
//  TapKit
//
//  Created by Rob Caraway on 7/23/19.
//  Copyright © 2019 Rob Caraway. All rights reserved.
//

import UIKit

extension UIViewController {
   
    public func getAllViews() -> [ViewResponse] {
        return getViewResponsesFromVariables()
    }
    
    private func getViewResponsesFromVariables(reflect: Mirror? = nil) -> [ViewResponse] {
        let namedViews = getAllSubviewsFromInstanceVariables(reflect: reflect)
        var viewResponses: [ViewResponse] = []
        namedViews.forEach {
            viewResponses.append(getNewViewResponse(from: $0.1, name: $0.0))
        }
        return viewResponses
    }
    
    public func getUIViewsFromVariables(reflect: Mirror? = nil) -> [String : UIView] {
        let namedViews = getAllSubviewsFromInstanceVariables(reflect: reflect)
        var viewNameDict: [String : UIView] = [:]
        namedViews.forEach {
            viewNameDict[$0.0] = $0.1
        }
        return viewNameDict
    }
    
    private func getAllSubviewsFromInstanceVariables(reflect: Mirror? = nil) -> [(String, UIView)] {
        print("✅ TapFunnels: 👨‍👩‍👦‍👦 getAllSubviewsFromInstanceVariables() began")
        let mirror = reflect ?? Mirror(reflecting: self)
        
        var views: [(String, UIView)] = []
        if mirror.superclassMirror != nil && mirror.subjectType is UIViewController {
            views.append(contentsOf: getAllSubviewsFromInstanceVariables())
        }
        for (_, attribute) in mirror.children.enumerated() {
            if let propertyName = attribute.label {
                if let viewController = attribute.value as? UIViewController {
                   //FIXME: be weary of casting to UIViewController, it might not work properly
                    views.append(contentsOf: viewController.getAllSubviewsFromInstanceVariables())
                }
                if let uiView = attribute.value as? UIView {
                    let name = "\(NSStringFromClass(type(of: self))).\(propertyName)"
                    views.append((name, uiView))
                }
            }
        }
        print("✅ TapFunnels: 👨‍👩‍👦‍👦 getAllSubviewsFromInstanceVariables() returned views: \(views)")
        return views
    }
    
    private func getNewViewResponse(from view: UIView, name: String = "") -> ViewResponse {
        let color: UIColor = view.backgroundColor ?? .clear
        return ViewResponse(name: name,
                                    colorRed:color.red(),
                                    colorBlue: color.blue(),
                                    colorGreen: color.green(),
                                    dateModified: Date())
        
    }
    
}

