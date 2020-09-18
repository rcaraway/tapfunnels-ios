//
//  File.swift
//  
//
//  Created by Rob Caraway on 8/16/20.
//
#if !os(macOS)
import UIKit

public typealias HexString = String

public struct ViewStore {
    let name: String
    let frame: CGRect?
    let backgroundColor: HexString
}

public extension UIScreen {
    static func readableScreenSize() -> String {
        return "\(Int(UIScreen.main.bounds.width)) x \(Int(UIScreen.main.bounds.height))"
    }
    
    static func screenWidth() -> Int {
        return Int(UIScreen.main.bounds.width)
    }
    
    static func screenHeight() -> Int {
        return Int(UIScreen.main.bounds.height)
    }
}
#endif
