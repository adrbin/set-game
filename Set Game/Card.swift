//
//  Card.swift
//  Set Game
//
//  Created by Adrian on 2017/12/11.
//  Copyright © 2017 Adrian. All rights reserved.
//

import Foundation

struct Card: Hashable {
    let number: Number
    let shape: Shape
    let shading: Shading
    let color: Color
    
    var hashValue: Int {
        return number.rawValue * pow(Number.count, 3) + shape.rawValue * pow(Shape.count, 2) + shading.rawValue * pow(Shading.count, 1) + color.rawValue * pow(Color.count, 0)
    }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.number == rhs.number && lhs.shape == rhs.shape && lhs.shading == rhs.shading && lhs.color == rhs.color
    }
    
    enum Number: Int {
        case one = 1
        case two
        case three
        
        static var count: Int {
            return all.count
        }
        
        static var all: [Number] {
            return [.one, .two, .three]
        }
    }
    
    enum Shape: Int {
        case diamond = 1
        case squiggle
        case oval
        
        static var count: Int {
            return all.count
        }
        
        static var all: [Shape] {
            return [.diamond, .squiggle, .oval]
        }
        
    }
    
    enum Shading: Int {
        case solid = 1
        case strip
        case open
        
        static var count: Int {
            return all.count
        }
        
        static var all: [Shading] {
            return [.solid, .strip, .open]
        }
    }
    
    enum Color: Int {
        case red = 1
        case green
        case purple
        
        static var count: Int {
            return all.count
        }
        
        static var all: [Color] {
            return [.red, .green, .purple]
        }
    }
}

    func pow(_ x: Int, _ y: Int) -> Int {
        return Int(truncating: NSDecimalNumber(decimal: pow(Decimal(x), y)))
    }
