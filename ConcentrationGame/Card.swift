//
//  Card.swift
//  ConcentrationGame
//
//  Created by SP4RK on 06/05/2019.
//  Copyright © 2019 SP4RK. All rights reserved.
//

import Foundation

struct Card : Hashable {
    var isFaceUp = false
    var isMatched = false
    var identifier: Int
    
    func hash() -> Int {
        return identifier
    }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private static var identifierFactory = 0
    private static func uniqueIdentifierGenerator() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    init () {
        identifier = Card.uniqueIdentifierGenerator()
    }
}
