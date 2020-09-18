//
//  View+Conversion.swift
//  TapKit
//
//  Created by Rob Caraway on 7/23/19.
//  Copyright © 2019 Rob Caraway. All rights reserved.
//

import UIKit
import CoreData

extension View {
    @discardableResult static func addView(from response: ViewResponse, context: NSManagedObjectContext) -> View {
        guard let view = NSEntityDescription.insertNewObject(forEntityName: "View", into: context) as? View else {
            fatalError("Cannot create entity as non view")
        }
        view.setValue(response.colorBlue, forKey: "colorBlue")
        view.setValue(response.colorRed, forKey: "colorRed")
        view.setValue(response.colorGreen, forKey: "colorGreen")
        view.setValue(response.name, forKey: "name")
        return view
    }
    
    func viewResponse() -> ViewResponse? {
        guard let name = value(forKey: "name") as? String,
            let colorRed = value(forKey: "colorRed") as? Float,
            let colorGreen = value(forKey: "colorGreen") as? Float,
            let colorBlue = value(forKey: "colorBlue") as? Float,
            let date = value(forKey: "dateModified") as? Date else {
                return nil
        }
        return ViewResponse(name: name, colorRed: colorRed, colorBlue: colorBlue, colorGreen: colorGreen, dateModified: date)
    }
}

public extension UIView {
    func translate(view: View) {
        backgroundColor = UIColor(red: CGFloat(view.colorRed)/255.0,
                                  green:  CGFloat(view.colorGreen)/255.0,
                                  blue:  CGFloat(view.colorBlue)/255.0, alpha: 1.0)
        
    }
}
