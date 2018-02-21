//
//  CardView.swift
//  Set Game
//
//  Created by Adrian on 2018/02/19.
//  Copyright © 2018 Adrian. All rights reserved.
//

import UIKit

@IBDesignable
class CardView: UIView {
    var color: Card.Color = .red { didSet {setNeedsDisplay()}}
    var number: Card.Number = .three { didSet {setNeedsDisplay()}}
    var shading: Card.Shading = .open { didSet {setNeedsDisplay()}}
    var shape: Card.Shape = .oval { didSet {setNeedsDisplay()}}
    @IBInspectable
    var selected: Bool = false
    @IBInspectable
    var hinted: Bool = false
    
    @IBInspectable
    var lineWidth: CGFloat = 2.0 { didSet {setNeedsDisplay()}}
    lazy var borderWidth: CGFloat = lineWidth * 6
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        let rect = rect.zoom(by: SizeRatio.cardToBounds)
        drawBackground(in: rect)
        let offsettedRect = rect.zoom(by: SizeRatio.zoomFactor)
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        drawCard(with: path, in: offsettedRect)
        chooseColor()
        drawShading(with: path, in: rect)
    }
    
    private func drawBackground(in rect: CGRect) {
        backgroundColor = UIColor.clear
        let roundedRect = UIBezierPath(roundedRect: rect, cornerRadius: 16.0)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        if selected {
            roundedRect.lineWidth = borderWidth
            UIColor.magenta.setStroke()
            roundedRect.stroke()
        }
        if hinted {
            roundedRect.lineWidth = borderWidth
            UIColor.orange.setStroke()
            roundedRect.stroke()
        }
    }
    
    private func drawCard(with path: UIBezierPath, in rect: CGRect) {
        switch number {
        case .one:
            let offsettedRect = rect.upperHalf.offsetBy(dx: 0, dy: rect.height / 4)
            drawShape(with: path, in: offsettedRect)
        case .two:
            let offsettedUpperRect = rect.upperHalf.zoom(by: SizeRatio.zoomFactor)
            drawShape(with: path, in: offsettedUpperRect)
            let offsettedLowerRect = rect.lowerHalf.zoom(by: SizeRatio.zoomFactor)
            drawShape(with: path, in: offsettedLowerRect)
        case .three:
            let size = CGSize(width: rect.width, height: rect.height / 3)
            let firstRect = CGRect(origin: rect.origin, size: size)
            let offsettedFirstRect = firstRect.zoom(by: SizeRatio.zoomFactor)
            drawShape(with: path, in: offsettedFirstRect)
            let secondRect = CGRect(origin: rect.origin.offsetBy(dx: 0, dy: rect.height / 3), size: size)
            let offsettedSecondRect = secondRect.zoom(by: SizeRatio.zoomFactor)
            drawShape(with: path, in: offsettedSecondRect)
            let thirdRect = CGRect(origin: rect.origin.offsetBy(dx: 0, dy: rect.height * 2 / 3), size: size)
            let offsettedThirdRect = thirdRect.zoom(by: SizeRatio.zoomFactor)
            drawShape(with: path, in: offsettedThirdRect)
        }
    }
    
    
    private func drawShape(with path: UIBezierPath, in rect: CGRect) {
        switch shape {
        case .diamond:
            path.move(to: rect.origin.offsetBy(dx: 0, dy: rect.height / 2))
            path.addLine(to: rect.origin.offsetBy(dx: rect.width / 2, dy: rect.height * SizeRatio.diamondYToRectHeight))
            path.addLine(to: rect.origin.offsetBy(dx: rect.width, dy: rect.height / 2))
            path.addLine(to: rect.origin.offsetBy(dx: rect.width / 2, dy: rect.height * (1 - SizeRatio.diamondYToRectHeight)))
            path.close()
        case .oval:
            let partialPath = UIBezierPath(ovalIn: rect)
            path.append(partialPath)
        case .squiggle:
            let squiglePartWidth = rect.width * (1 / 3)
            path.move(to: rect.origin.offsetBy(dx: 0, dy: rect.size.height))
            path.addQuadCurve(to: rect.origin.offsetBy(dx: squiglePartWidth * 2, dy: rect.height * SizeRatio.squigleYToRectHeight), controlPoint: rect.origin)
            path.addQuadCurve(to: rect.origin.offsetBy(dx: rect.size.width, dy: 0), controlPoint: rect.origin.offsetBy(dx: squiglePartWidth * 2.5, dy: rect.height * SizeRatio.squigleYToRectHeight))
            path.addQuadCurve(to: rect.origin.offsetBy(dx: squiglePartWidth, dy: rect.height * (1 - SizeRatio.squigleYToRectHeight)), controlPoint: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addQuadCurve(to: rect.origin.offsetBy(dx: 0, dy: rect.height), controlPoint: rect.origin.offsetBy(dx: squiglePartWidth * 0.5, dy: rect.height * (1 - SizeRatio.squigleYToRectHeight)))
            
        }
    }
    
    private func chooseColor() {
        switch color {
        case .green:
            UIColor.green.setFill()
            UIColor.green.setStroke()
        case .purple:
            UIColor.purple.setFill()
            UIColor.purple.setStroke()
        case .red:
            UIColor.red.setFill()
            UIColor.red.setStroke()
        }
    }
    
    private func drawShading(with path: UIBezierPath, in rect: CGRect) {
        path.stroke()
        switch shading {
        case .open:
            UIColor.clear.setFill()
        case .strip:
            if let context = UIGraphicsGetCurrentContext() {
                context.saveGState()
                path.addClip()
                let linesPath = UIBezierPath()
                linesPath.lineWidth = lineWidth / 2
                for i in stride(from: 0, through: rect.width, by: linesPath.lineWidth * 3) {
                    linesPath.move(to: CGPoint(x: i, y: rect.minY))
                    linesPath.addLine(to: CGPoint(x: i, y: rect.maxY))
                }
                linesPath.stroke()
                context.restoreGState()
            }
        case .solid:
            path.fill()
        }
    }
}

extension CardView {
    private struct SizeRatio {
        static let diamondYToRectHeight: CGFloat = 1/6
        static let squigleYToRectHeight: CGFloat = 0.1
        static let offsetToRectWidth: CGFloat = 0.1
        static let cardToBounds: CGFloat = 0.9
        static let zoomFactor: CGFloat = 0.8
    }
    
    @IBInspectable var colorAdapter: Int {
        get {
            return color.rawValue
        }
        set {
            color = Card.Color(rawValue: newValue) ?? .green
        }
    }
    
    @IBInspectable var numberAdapter: Int {
        get {
            return number.rawValue
        }
        set {
            number = Card.Number(rawValue: newValue) ?? .one
        }
    }
    
    @IBInspectable var shapeAdapter: Int {
        get {
            return shape.rawValue
        }
        set {
            shape = Card.Shape(rawValue: newValue) ?? .diamond
        }
    }
    
    @IBInspectable var ShadingAdapter: Int {
        get {
            return shading.rawValue
        }
        set {
            shading = Card.Shading(rawValue: newValue) ?? .open
        }
    }
    
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
}

extension CGRect {
    func zoom(by zoomFactor: CGFloat) -> CGRect {
        let zoomedWidth = size.width * zoomFactor
        let zoomedHeight = size.height * zoomFactor
        let originX = origin.x + (size.width - zoomedWidth) / 2
        let originY = origin.y + (size.height - zoomedHeight) / 2
        return CGRect(origin: CGPoint(x: originX,y: originY) , size: CGSize(width: zoomedWidth, height: zoomedHeight))
    }
    
    var leftHalf: CGRect {
        let width = size.width / 2
        return CGRect(origin: origin, size: CGSize(width: width, height: size.height))
    }
    
    var rightHalf: CGRect {
        let width = size.width / 2
        return CGRect(origin: CGPoint(x: origin.x + width, y: origin.y), size: CGSize(width: width, height: size.height))
    }
    
    var upperHalf: CGRect {
        let height = size.height / 2
        return CGRect(origin: origin, size: CGSize(width: size.width, height: height))
    }
    
    var lowerHalf: CGRect {
        let height = size.height / 2
        return CGRect(origin: CGPoint(x: origin.x, y: origin.y + height), size: CGSize(width: size.width, height: height))
    }
}
