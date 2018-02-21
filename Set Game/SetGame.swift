//
//  SetGame.swift
//  Set Game
//
//  Created by Adrian on 2017/12/11.
//  Copyright © 2017 Adrian. All rights reserved.
//

import Foundation

class SetGame {
    private(set) var cardsInTheDeck = [Card]()
    private(set) var cardsOnTheTable = [Card]()
    private(set) var cardsMatched = [Card]()
    private(set) var selectedCards = [Card]()
    private(set) var  hinted = false
    
    private(set) var score = 0
    private(set) var numberOfCardsToDraw: Int
    
    func chooseCard(_ card: Card) {
        if selectedCards.contains(card) && selectedCards.count < Card.Number.count { // card unselected
            selectedCards.remove(at: selectedCards.index(of: card)!)
            score -= 1
        } else {
            switch selectedCards.count {
            case Card.Number.count - 1: // picking the 3rd card
                selectedCards.append(card)
                if selectedCardsMatch {
                    score += 3
                } else {
                    score -= 5
                }
            case Card.Number.count:
                dealCards(n: numberOfCardsToDraw)
                selectedCards = [card]
            default:
                selectedCards.append(card)
            }
        }
    }
    
    func findMatches() {
        if let matches = findMatches(in: cardsOnTheTable) {
            hinted = true
            selectedCards = matches
        }
}
    
    func findMatches(in cards: [Card]) -> [Card]? {
        for card1 in cards {
            for card2 in cards {
                for card3 in cards {
                    let cardsToCheck = [card1, card2, card3]
                    if card1 != card2 && card1 != card3 && card2 != card3 {
                        if cardsMatch(cardsToCheck) {
                            return cardsToCheck
                        }
                    }
                }
            }
        }
        return nil
    }
    
//    func insert(_ card: Card, to cards: Set<Card>?) -> Set<Card> {
//        guard var cardsInSet = cards else { return Set<Card>() }
//        cardsInSet.insert(card)
//        return cardsInSet
//    }
    
    var selectedCardsMatch: Bool {
        return cardsMatch(selectedCards)
    }
    
    func cardsMatch(_ cards: [Card]) -> Bool {
        let numbers = Set(cards.map {$0.number})
        let shapes = Set(cards.map {$0.shape})
        let shadings = Set(cards.map {$0.shading})
        let colors = Set(cards.map {$0.color})
        
        let numbersAllTheSame = numbers.count == 1
        let shapesAllTheSame = shapes.count == 1
        let shadingsAllTheSame = shadings.count == 1
        let colorsAllTheSame = colors.count == 1
        
        
        let numbersAllDifferent = numbers.count == Card.Number.count
        let shapesAllDifferent = shapes.count == Card.Shape.count
        let shadingsAllDifferent = shadings.count == Card.Shading.count
        let colorsAllDifferent = colors.count == Card.Color.count
        
        //        return numbersAllTheSame || shapesAllTheSame || shadingsAllTheSame || colorsAllTheSame || numbersAllDifferent || shapesAllDifferent || shadingsAllDifferent || colorsAllDifferent
        
        return (numbersAllTheSame || numbersAllDifferent) && (shapesAllTheSame || shapesAllDifferent) && (shadingsAllTheSame || shadingsAllDifferent) && (colorsAllTheSame || colorsAllDifferent)
    }
    
    private func shuffleCardsInTheDeck() {
        for index in cardsInTheDeck.indices {
            let randomIndex = index.arc4random
            cardsInTheDeck.swapAt(index, randomIndex)
        }
    }
    
    func shuffleCardsOnTheTable() {
        for index in cardsOnTheTable.indices {
            let randomIndex = index.arc4random
            cardsOnTheTable.swapAt(index, randomIndex)
        }
    }
    
    func dealCards(n number: Int) {
        if selectedCards.count == Card.Number.count {
            if selectedCardsMatch {
                for selectedCard in selectedCards {
                    let index = cardsOnTheTable.index(where: {$0 == selectedCard})!
                    if cardsInTheDeck.count > 0 {
                        cardsOnTheTable[index] = cardsInTheDeck.removeLast()
                    } else {
                        cardsOnTheTable.remove(at: index)
                    }
                }
                hinted = false
            }
            selectedCards = []
        } else {
            for _ in 0..<number {
                if cardsInTheDeck.count > 0 {
                    cardsOnTheTable.append(cardsInTheDeck.removeLast())
                }
            }
        }
    }
    
    init(numberOfStartingCards: Int, numberOfCardsToDraw: Int) {
        self.numberOfCardsToDraw = numberOfCardsToDraw
        for number in Card.Number.all {
            for shape in Card.Shape.all {
                for shading in Card.Shading.all {
                    for color in Card.Color.all {
                        cardsInTheDeck.append(Card(number: number, shape: shape, shading: shading, color: color))
                    }
                }
            }
        }
        shuffleCardsInTheDeck()
        dealCards(n: numberOfStartingCards)
        score = 0
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

extension Collection {
    func all(predicate: (Element)->(Bool)) -> Bool {
        return filter(predicate).count == count
    }
}
