//
//  PriceLineView.swift
//  CryptopiaTrader
//
//  Created by Florin Uscatu on 9/26/17.
//  Copyright © 2017 Florin Uscatu. All rights reserved.
//

import UIKit

class PriceLineView: UIView {
    
    var lowestPrice = Double() {
        didSet {
            drawLine()
        }
    }
    var highestPrice = Double()
    var currentPrice = Double()
    
    func drawLine() {
        //self.backgroundColor = UIColor.white
        
        let linePath = UIBezierPath()
        
        linePath.move(to: CGPoint(x: 0, y: self.bounds.height/2))
        linePath.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height/2))
        
        linePath.move(to: CGPoint(x: 0, y: self.bounds.height/2 - 4))
        linePath.addLine(to: CGPoint(x: 0, y: self.bounds.height/2 + 4))
        
        linePath.move(to: CGPoint(x: self.bounds.width, y: self.bounds.height/2 - 4))
        linePath.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height/2 + 4))
        
        let line = CAShapeLayer()
        line.strokeColor = UIColor.black.cgColor
        line.path = linePath.cgPath
        layer.addSublayer(line)
        
        let locationOfIndicator = CGFloat((currentPrice - lowestPrice) / (highestPrice - lowestPrice)) * self.bounds.width
        
        let indicatorPath = UIBezierPath()
        
        indicatorPath.move(to: CGPoint(x: (locationOfIndicator - 4), y: self.bounds.height/2 - 8))
        indicatorPath.addLine(to: CGPoint(x: (locationOfIndicator + 4), y: self.bounds.height/2 - 8))
        indicatorPath.addLine(to: CGPoint(x: (locationOfIndicator), y: self.bounds.height/2))
        indicatorPath.close()
        
        let indicator = CAShapeLayer()
        indicator.strokeColor = UIColor.black.cgColor
        indicator.path = indicatorPath.cgPath
        layer.addSublayer(indicator)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        drawLine()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        drawLine()
    }
}

