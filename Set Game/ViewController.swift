//
//  ViewController.swift
//  Set Game
//
//  Created by Adrian on 2017/12/11.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let numberOfCardsToDraw = 3
    
    private(set) lazy var game = newSetGame()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        updateViewFromModel()
        dealCardsButton.layer.cornerRadius = 3.0
        hintButton.layer.cornerRadius = 3.0
        newGameButton.layer.cornerRadius = 3.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet private var cardButtons: [UIButton]!
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardIndex = cardButtons.index(of: sender) {
            if let card = game.cardsOnTheTable[cardIndex] {
                game.chooseCard(card)
            }
        }
        updateViewFromModel()
    }
    
    func updateViewFromModel() {
        scoreLabel.text = "Score: \(game.score)"
        if game.cardsInTheDeck.isEmpty {
            dealCardsButton.setTitle("Take cards", for: UIControlState.normal)
        }
        for index in cardButtons.indices {
            let button = cardButtons[index]
            if let card = game.cardsOnTheTable[index] {
                button.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                button.layer.cornerRadius = 8.0
                let attributedString = NSAttributedString(string: text(for: card), attributes: attributes(for: card))
                button.setAttributedTitle(attributedString, for: UIControlState.normal)
                if game.selectedCards.contains(card) {
                    button.layer.borderWidth = 5.0
                    if game.hinted {
                        button.layer.borderColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1).cgColor
                    } else {
                        button.layer.borderColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1).cgColor
                    }
                } else {
                    button.layer.borderWidth = 0.0
                    button.layer.borderColor = nil
                }
            } else {
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                button.setTitle(nil, for: UIControlState.normal)
                button.setAttributedTitle(nil, for: UIControlState.normal)
                button.layer.borderWidth = 0.0
                button.layer.borderColor = nil
            }
        }
        if game.cardsOnTheTable.filter({$0 != nil}).count - game.selectedCards.count <= 0 {
            let alert = UIAlertController(title: "You have won!", message: "You should be proud of yourself. Now you can just give me $1000 and shut up", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: {self.startNewGame()})
        }
    }
    
    func text(for card: Card) -> String {
        return String(repeating: shape(for: card), count: card.number.rawValue)
    }
    
    func attributes(for card: Card) -> [NSAttributedStringKey: Any] {
        var attributes = shading(for: card)
        attributes[NSAttributedStringKey.font] = UIFont.systemFont(ofSize: 30.0)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        attributes[NSAttributedStringKey.paragraphStyle] = paragraphStyle
        return attributes
    }
    
    func shape(for card: Card) -> String {
        switch card.shape {
        case .diamond:
            return "✦"
        case .oval:
            return "⚫︎"
        case .squiggle:
            return "❤︎"
        }
    }
    
    
    func color(for card: Card) -> UIColor {
        switch card.color {
        case .green:
            return #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        case .purple:
            return #colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1)
        case .red:
            return #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        }
    }
    
    func shading(for card: Card) -> [NSAttributedStringKey: Any] {
        switch card.shading {
        case .open:
            return [NSAttributedStringKey.strokeColor: color(for: card), NSAttributedStringKey.strokeWidth: 5.0]
        case .solid:
            return [NSAttributedStringKey.foregroundColor: color(for: card)]
        case .strip:
            return [NSAttributedStringKey.strokeColor: color(for: card), NSAttributedStringKey.strokeWidth: -5.0, NSAttributedStringKey.foregroundColor: color(for: card).withAlphaComponent(0.30)]
        }
    }
    
    @IBOutlet weak var dealCardsButton: UIButton!
    @IBAction private func touchDealCards(_ sender: UIButton) {
//        if game.cardsOnTheTable.filter({$0 != nil}).count < game.maxCardsOnTheTable {
            game.dealCards(n: numberOfCardsToDraw)
            updateViewFromModel()
//        }
    }
    
    
    @IBOutlet weak var hintButton: UIButton!
    @IBAction func touchHint(_ sender: UIButton) {
        game.findMatches()
        updateViewFromModel()
        if !game.hinted {
            let alert = UIAlertController(title: "There are no matches", message: "Deal new cards to see if cards will match or start a new game", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBOutlet private weak var scoreLabel: UILabel!
    
    @IBOutlet weak var newGameButton: UIButton!
    func newSetGame() -> SetGame {
        return SetGame(numberOfStartingCards: cardButtons.count / 2, maxCardsOnTheTable: cardButtons.count, numberOfCardsToDraw: numberOfCardsToDraw)
    }
    
    @IBAction private func touchNewGame(_ sender: UIButton) {
        startNewGame()
    }
    
    func startNewGame() {
        game = newSetGame()
        updateViewFromModel()
    }
    
}

