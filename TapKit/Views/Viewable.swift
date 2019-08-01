//
//  Viewable.swift
//  TapKit
//
//  Created by Rob Caraway on 7/29/19.
//  Copyright © 2019 Rob Caraway. All rights reserved.
//

import Foundation

public protocol Viewable {
    var name: String { get }
    var colorRed: Float { get }
    var colorBlue: Float { get }
    var colorGreen: Float { get }
    var dateModified: Date { get}
}

extension Viewable where Self:Hashable {
    public var hashValue: Int {
        return name.hashValue ^ colorGreen.hashValue ^ colorBlue.hashValue ^ colorRed.hashValue
    }
}

extension Viewable where Self:Equatable {
    public static func ==(lhs: Viewable, rhs: Viewable) -> Bool {
        return lhs.name == rhs.name && lhs.dateModified == rhs.dateModified
    }
}

public struct ViewResponse: Codable, Viewable, Hashable, Equatable {
    public let name: String
    public let colorRed: Float
    public let colorBlue: Float
    public let colorGreen: Float
    public let dateModified: Date
}
