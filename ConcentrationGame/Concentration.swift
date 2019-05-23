//
//  Concentration.swift
//  ConcentrationGame
//
//  Created by SP4RK on 06/05/2019.
//  Copyright © 2019 SP4RK. All rights reserved.
//

import Foundation

class Concentration {
    private(set) var cards = [Card]()
    
    private(set) var flipCount = 0
    private(set) var score = 0
    var turnOverTimer : Timer?
    
    private var indexOfOnlyUpCard:Int? {
        get {
            return cards.indices.filter{cards[$0].isFaceUp}.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    var delegate: ConcentrarionDelegate?
    var cardsFacedUp = 0
    private var lastOpened = Date().timeIntervalSince1970
    
    private var seen = Set<Int>()
    
    func pressCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.pressCard(at: \(index)): chosen index not in the cards")
        if (!cards[index].isMatched && !cards[index].isFaceUp) {
            flipCount += 1
        }
        stopTimer()
        if (!cards[index].isMatched) {
            cardsFacedUp += 1
            if let matchedIndex = indexOfOnlyUpCard, matchedIndex != index {
                cardsFacedUp = 2
                cards[index].isFaceUp = true
                delegate?.didModifyCards()
                if cards[matchedIndex] == cards[index] {
                    cards[matchedIndex].isMatched = true
                    cards[index].isMatched = true
                    let curScore = Int(Date().timeIntervalSince1970 - lastOpened)
                    lastOpened = Date().timeIntervalSince1970
                    score += curScore
                } else {
                    if seen.contains(index) {
                        score += 30
                    }
                }
                startTimer()
            } else {
                indexOfOnlyUpCard = index
                delegate?.didModifyCards()
            }
        }
        seen.insert(index)
    }
    
    func startTimer () {
        if turnOverTimer == nil {
            turnOverTimer =  Timer.scheduledTimer(
                timeInterval: 1.5,
                target      : self,
                selector    : #selector(closeAllCards),
                userInfo    : nil,
                repeats     : false)
        }
    }
    
    func stopTimer() {
        if turnOverTimer != nil {
            turnOverTimer!.invalidate()
            turnOverTimer = nil
        }
    }
    
    
    
    @objc func closeAllCards() {
        for index in cards.indices {
            cards[index].isFaceUp = false
        }
        delegate?.didModifyCards()
    }
    
    init(numberOfPairs: Int) {
        assert(numberOfPairs > 0, "Concentration.init(\(numberOfPairs)): number of pairs can't be zero or less")
        score = 0
        flipCount = 0
        cards.removeAll()
        for _ in 0..<numberOfPairs {
            let card = Card()
            cards += [card, card]
        }
        cards.shuffle()
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
