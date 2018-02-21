//
//  CardTableView.swift
//  Set Game
//
//  Created by Adrian on 2018/02/19.
//  Copyright © 2018 Adrian. All rights reserved.
//

import UIKit

class CardTableView: UIView {
    let aspectRatio: CGFloat = 3/5

    lazy var grid = Grid(layout: Grid.Layout.aspectRatio(aspectRatio), frame: bounds)
    
    lazy var cardViews = [CardView]()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        grid.frame = bounds
        for i in 0..<grid.cellCount {
            cardViews[i].frame = grid[i]!
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsLayout()
    }
    
    func addCardView(color: Card.Color, number: Card.Number, shading: Card.Shading, shape: Card.Shape, selected: Bool = false, hinted: Bool = false) -> CardView {
        let cardView = CardView()
        setCardView(cardView, color: color, number: number, shading: shading, shape: shape, selected: selected, hinted: hinted)
        cardView.isOpaque = false
        cardViews.append(cardView)
        grid.cellCount += 1
        addSubview(cardView)
        setNeedsLayout()
        return cardView
    }
    
    func setCardView(_ cardView: CardView, color: Card.Color, number: Card.Number, shading: Card.Shading, shape: Card.Shape, selected: Bool = false, hinted: Bool = false) {
        cardView.color = color
        cardView.number = number
        cardView.shading = shading
        cardView.shape = shape
        cardView.selected = selected
        cardView.hinted = hinted
    }
    
    func setCardView(at index: Int, color: Card.Color, number: Card.Number, shading: Card.Shading, shape: Card.Shape, selected: Bool = false, hinted: Bool = false) {
        let cardView = cardViews[index]
        setCardView(cardView, color: color, number: number, shading: shading, shape: shape, selected: selected, hinted: hinted)
        setNeedsLayout()
    }
    
    func removeCardView(at index: Int) {
        let card = cardViews.remove(at: index)
        card.removeFromSuperview()
        grid.cellCount -= 1
        setNeedsLayout()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
