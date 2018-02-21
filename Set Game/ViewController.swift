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
    let numberOfStartingCards = 6
    
    @IBOutlet weak var cardTableView: CardTableView!
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
    
    
    @objc private func selectCard(byHandlingGestureRecognizedBy gesture: UITapGestureRecognizer) {
        switch gesture.state {
        case .ended:
            if let cardView = gesture.view as? CardView {
                if let cardIndex = cardTableView.cardViews.index(of: cardView) {
                    if game.cardsOnTheTable.indices.contains(cardIndex) {
                        let card = game.cardsOnTheTable[cardIndex]
                        game.chooseCard(card)
                        updateViewFromModel()
                    }
                }
            }
        default:
            break
        }
    }
    
    func setCardsInCardTable() {
        var maxCardIndex = 0
        for i in 0..<game.cardsOnTheTable.count {
            let card = game.cardsOnTheTable[i]
            let isCardSelected = game.selectedCards.contains(card) && !game.hinted
            let isCardHinted = game.selectedCards.contains(card) && game.hinted
            if i >= cardTableView.cardViews.count {
                let cardView = cardTableView.addCardView(color: card.color, number: card.number, shading: card.shading, shape: card.shape, selected: isCardSelected, hinted: isCardHinted)
                let tap = UITapGestureRecognizer(target: self, action: #selector(selectCard(byHandlingGestureRecognizedBy:)))
                cardView.addGestureRecognizer(tap)
            } else {
                cardTableView.setCardView(at: i, color: card.color, number: card.number, shading: card.shading, shape: card.shape, selected: isCardSelected, hinted: isCardHinted)
            }
            maxCardIndex = i
        }
        let removeCardViewIndex = maxCardIndex + 1
        for _ in removeCardViewIndex..<cardTableView.cardViews.count {
            cardTableView.removeCardView(at: removeCardViewIndex)
        }
    }
    
    func updateViewFromModel() {
        scoreLabel.text = "Score: \(game.score)"
        if game.cardsInTheDeck.isEmpty {
            dealCardsButton.setTitle("Take cards", for: UIControlState.normal)
        }
        setCardsInCardTable()
        if game.cardsOnTheTable.count - game.selectedCards.count <= 0 {
            let alert = UIAlertController(title: "You have won!", message: "You should be proud of yourself. Now you can just give me $1000 and shut up", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: {self.startNewGame()})
        }
    }
    
    @IBAction func swipeDealCards(_ sender: UISwipeGestureRecognizer) {
        switch sender.state {
        case .ended:
            dealCards()
        default:
            break
        }
    }
    
    
    @IBOutlet weak var dealCardsButton: UIButton!
    @IBAction private func touchDealCards(_ sender: UIButton) {
            dealCards()
    }
    
    func dealCards() {
        game.dealCards(n: numberOfCardsToDraw)
        updateViewFromModel()
    }
    
    @IBAction func rotateShuffleCards(_ sender: UIRotationGestureRecognizer) {
        switch sender.state {
        case .ended:
            var rotation = sender.rotation
            if rotation < 0 {
                rotation = -rotation
            }
            if rotation > CGFloat.pi / 3 {
                game.shuffleCardsOnTheTable()
                updateViewFromModel()

            }
        default:
            break
        }
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
        return SetGame(numberOfStartingCards: numberOfStartingCards, numberOfCardsToDraw: numberOfCardsToDraw)
    }
    
    @IBAction private func touchNewGame(_ sender: UIButton) {
        startNewGame()
    }
    
    func startNewGame() {
        game = newSetGame()
        updateViewFromModel()
    }
    
}

