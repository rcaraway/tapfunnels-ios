//
//  UIColor+Components.swift
//  TapKit
//
//  Created by Rob Caraway on 7/30/19.
//  Copyright © 2019 Rob Caraway. All rights reserved.
//

import UIKit
import CoreImage

public extension UIColor {
    
    func red() -> Float {
        let ciColor = CIColor(color: self)
        return Float(ciColor.red)
    }
    
    func green() -> Float {
        let ciColor = CIColor(color: self)
        return Float(ciColor.green)
    }
    
    func blue() -> Float {
        let ciColor = CIColor(color: self)
        return Float(ciColor.blue)
    }
}
