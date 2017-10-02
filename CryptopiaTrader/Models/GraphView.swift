//
//  GraphView.swift
//  CryptopiaTrader
//
//  Created by Florin Uscatu on 9/26/17.
//  Copyright © 2017 Florin Uscatu. All rights reserved.
//

import UIKit

struct ChartData: Decodable {
    var date = Int()
    var high = Double()
    var low = Double()
    var open = Double()
    var close = Double()
}

@IBDesignable class GraphView: UIView {
    
    @IBInspectable var startColor = UIColor.white.cgColor
    @IBInspectable var endColor = UIColor.gray.cgColor
    
    var descriptionLabel = UILabel()
    
    var averageValueLabel = UILabel()
    
    var denomination: String = ""
    
    var graphData:[ChartData] = [] {
        didSet {
            for data in graphData {
                let tempDate = transformDate(unixDate: data.date, chartPer: chartPeriod!)
                dateStrings.append(tempDate)
            }
            drawGraph()
        }
    }
    
    var dateStrings:[String] = []
    var chartPeriod:Int?
    
//    let graphBackground = CAShapeLayer()
    let graphGridLineLayer = CAShapeLayer()
//    let whiteHaze = CALayer()
//    let gl = CAGradientLayer()
    
    var maxValue: Double {
        get {
            
            var points = [Double]()
            
            for point in graphData {
                points.append(point.high)
            }
            
            let currentMax = (points.max()!)
            return currentMax
        }
    }
    
    var minValue: Double {
        get {
            
            var points = [Double]()
            
            for point in graphData {
                points.append(point.low)
            }
            
            let currentMin = (points.min()!)
            return currentMin
        }
    }
    
    var valueLabels: Array<Double> {
        get {
            var tempArray = [Double]()
            
            tempArray.append(maxValue)
            tempArray.append(minValue)
            
            for i in 1...5 {
                let difference = maxValue - minValue
                
                let newLevel = minValue + Double(i)*(difference/5)
                
                tempArray.append(newLevel)
            }
            
            return tempArray
        }
    }
    
    override func setNeedsDisplay() 
    {
        draw(bounds)
    }
    
    func transformDate(unixDate: Int, chartPer: Int) -> String {
        var formattedUnixDate = unixDate
        if String(unixDate).count > 10 {
            formattedUnixDate = Int(unixDate/1000)
        }
        
        let date = NSDate(timeIntervalSince1970: TimeInterval(formattedUnixDate))
        let dateFormatter = DateFormatter()
        if chartPer == 1440 {
            dateFormatter.dateFormat = "dd/MM"
        } else {
            dateFormatter.dateFormat = "HH:mm"
        }
        let dateString = dateFormatter.string(from: date as Date)
        
        return dateString
    }
    
    func createCandleLine(yPadding: CGFloat, ySegmentsPoints: CGFloat, xPosition: CGFloat, yPosition: CGFloat, openPrice: Double, closePrice: Double, highestPrice: Double, lowestPrice: Double) -> UIBezierPath {
        
        let candlePath = UIBezierPath()
        
        let extremeTop = ySegmentsPoints * CGFloat(maxValue - highestPrice) + yPadding
        let extremeBottom = ySegmentsPoints * CGFloat(maxValue - lowestPrice) + yPadding
        
        candlePath.move(to: CGPoint(x: xPosition, y: extremeTop))
        candlePath.addLine(to: CGPoint(x: xPosition, y: extremeBottom))
        
        return candlePath
        
    }
    
    func createCandleBody(yPadding: CGFloat, ySegmentsPoints: CGFloat, xPosition: CGFloat, yPosition: CGFloat, openPrice: Double, closePrice: Double, highestPrice: Double, lowestPrice: Double) -> UIBezierPath {
        
        let candlePath = UIBezierPath()
        
        let topOfCandle = ySegmentsPoints * CGFloat(maxValue - openPrice) + yPadding
        let bottomOfCandle = ySegmentsPoints * CGFloat(maxValue - closePrice) + yPadding
        
        candlePath.move(to: CGPoint(x: xPosition - 2.5, y: topOfCandle))
        candlePath.addLine(to: CGPoint(x: xPosition + 2.5, y: topOfCandle))
        candlePath.addLine(to: CGPoint(x: xPosition + 2.5, y: bottomOfCandle))
        candlePath.addLine(to: CGPoint(x: xPosition - 2.5, y: bottomOfCandle))
        candlePath.close()
        
        return candlePath
        
    }
    
    func drawGraph() {
        backgroundColor = UIColor.clear
        
//        gl.frame = bounds
//        gl.colors = [startColor, endColor]
//        gl.locations = [0.0, 1.0]
//
//        layer.addSublayer(gl)
        
        let frame = UIBezierPath(roundedRect: bounds, cornerRadius: 8.0)
        
//        graphBackground.path = frame.cgPath
//
//        graphBackground.strokeColor = UIColor.clear.cgColor
//        graphBackground.fillColor = UIColor.black.cgColor
//
//        layer.mask = graphBackground
//
//        whiteHaze.frame = bounds
//        whiteHaze.backgroundColor = UIColor(white: 1.0, alpha: 0.3).cgColor
//
//        layer.addSublayer(whiteHaze)
//
//        layer.mask = graphBackground
        
        if graphData.count > 3 {
            
            let yPadding = CGFloat(40)
            let xPadding = CGFloat(15)
            
            descriptionLabel.frame = CGRect(x: xPadding, y: CGFloat(5), width: CGFloat(100), height: CGFloat(15))
            descriptionLabel.font = UIFont(name: "Helvetica", size: 12)
            descriptionLabel.textColor = UIColor.black
            self.addSubview(descriptionLabel)
            
            averageValueLabel.text = "Last price: \((String(format: "%.8f",(graphData.last?.close)!))) \(denomination)"
            averageValueLabel.frame = CGRect(x: xPadding, y: CGFloat(20), width: self.bounds.width, height: CGFloat(15))
            averageValueLabel.font = UIFont(name: "Helvetica", size: 12)
            averageValueLabel.textColor = UIColor.black
            self.addSubview(averageValueLabel)
            
            let gridLinePath = UIBezierPath()
            
            let ySegments = (frame.bounds.height - yPadding*2) / CGFloat(maxValue - minValue)
            
            for value in valueLabels {
                
                let yPosition = ySegments * (CGFloat(maxValue) - CGFloat(value)) + yPadding
                
                let valueLabel = UILabel(frame: CGRect(x: frame.bounds.width - CGFloat(40), y: yPosition - 10, width: 40, height: 20))
                valueLabel.font = UIFont(name: "Helvetica", size: 5)
                valueLabel.text = String(format: "%.8f", value)
                valueLabel.textColor = UIColor.black
                self.addSubview(valueLabel)
                
                gridLinePath.move(to: CGPoint(x: xPadding, y: yPosition))
                gridLinePath.addLine(to: CGPoint(x: frame.bounds.width-xPadding-30, y: yPosition))
                
                
            }
            
            for (i, dateString) in dateStrings.enumerated() {
                
                let limit = Int(dateStrings.count / 5)
                
                if i % limit == 0 {
                    let xPosition = ((frame.bounds.width - 2*xPadding - 30)/CGFloat(graphData.count - 1)) * CGFloat(i) + xPadding - 5
                    let countingLabel = UILabel(frame: CGRect(x: xPosition, y: frame.bounds.height - 20, width: 40, height: 20))
                    countingLabel.text = "\(dateString)"
                    countingLabel.textAlignment = .center
                    countingLabel.font = UIFont(name: "Helvetica", size: 9)
                    countingLabel.textColor = UIColor.black
                    self.addSubview(countingLabel)

                }
                
            }
            
            graphGridLineLayer.path = gridLinePath.cgPath
            graphGridLineLayer.fillColor = UIColor.clear.cgColor
            graphGridLineLayer.strokeColor = UIColor(white: 0, alpha: 0.5).cgColor
            
            layer.addSublayer(graphGridLineLayer)
            
            let graphLine = UIBezierPath()
            
            let ySegmentsPoints = (frame.bounds.height - yPadding*2) / CGFloat(maxValue - minValue)
            let yPositionPoints = ySegmentsPoints * CGFloat(maxValue - graphData[0].close) + yPadding
            
            let pointsPath = UIBezierPath()
            
            graphLine.move(to: CGPoint(x: xPadding, y: yPositionPoints ))
            
            let candleLineLayerPath = createCandleLine(yPadding: yPadding, ySegmentsPoints: ySegmentsPoints, xPosition: xPadding, yPosition: yPositionPoints, openPrice: graphData[0].open, closePrice: graphData[0].close, highestPrice: graphData[0].high, lowestPrice: graphData[0].low)
            
            let candleBodyLayerPath = createCandleBody(yPadding: yPadding, ySegmentsPoints: ySegmentsPoints, xPosition: xPadding, yPosition: yPositionPoints, openPrice: graphData[0].open, closePrice: graphData[0].close, highestPrice: graphData[0].high, lowestPrice: graphData[0].low)
            
            for point in 1...(graphData.count - 1) {
                let yPositionPoint = ySegmentsPoints * CGFloat(maxValue - graphData[point].close) + yPadding
                let xPositionPoint = ((frame.bounds.width - 2*xPadding - 30)/CGFloat(graphData.count - 1))*CGFloat(point)+xPadding
                graphLine.addLine(to: CGPoint(x: xPositionPoint, y: yPositionPoint ))
                pointsPath.move(to: CGPoint(x: xPositionPoint, y: yPositionPoint))
                
                let disposableGraphCandleLineLayerPath = createCandleLine(yPadding: yPadding, ySegmentsPoints: ySegmentsPoints, xPosition: xPositionPoint, yPosition: yPositionPoint, openPrice: graphData[point].open, closePrice: graphData[point].close, highestPrice: graphData[point].high, lowestPrice: graphData[point].low)
                
                let disposableGraphCandleLineLayer = CAShapeLayer()
                disposableGraphCandleLineLayer.strokeColor = UIColor.black.cgColor
                disposableGraphCandleLineLayer.path = disposableGraphCandleLineLayerPath.cgPath
                layer.addSublayer(disposableGraphCandleLineLayer)
                
                let disposableGraphCandleBodyLayerPath = createCandleBody(yPadding: yPadding, ySegmentsPoints: ySegmentsPoints, xPosition: xPositionPoint, yPosition: yPositionPoint, openPrice: graphData[point].open, closePrice: graphData[point].close, highestPrice: graphData[point].high, lowestPrice: graphData[point].low)
                
                let disposableGraphCandleBodyLayer = CAShapeLayer()
                if graphData[point].close < graphData[point].open {
                    disposableGraphCandleBodyLayer.fillColor = UIColor.red.cgColor
                } else {
                    disposableGraphCandleBodyLayer.fillColor = UIColor.green.cgColor
                }
                disposableGraphCandleBodyLayer.path = disposableGraphCandleBodyLayerPath.cgPath
                layer.addSublayer(disposableGraphCandleBodyLayer)
            }
            
            let graphCandleLineLayer = CAShapeLayer()
            graphCandleLineLayer.strokeColor = UIColor.black.cgColor
            graphCandleLineLayer.path = candleLineLayerPath.cgPath
            layer.addSublayer(graphCandleLineLayer)
            
            let graphCandleBodyLayer = CAShapeLayer()
            if graphData[0].close < graphData[0].open {
                graphCandleBodyLayer.fillColor = UIColor.red.cgColor
            } else {
                graphCandleBodyLayer.fillColor = UIColor.green.cgColor
            }
            graphCandleBodyLayer.path = candleBodyLayerPath.cgPath
            layer.addSublayer(graphCandleBodyLayer)
            
        } else {
//            
//            print("showing error label")
//            
//            let errorLabel = UILabel()
//            
//            errorLabel.frame = CGRect(x: self.bounds.width/2 - 125, y: self.bounds.height/2 - 10 , width: 250, height: 20)
//            errorLabel.font = UIFont(name: "Helvetica", size: 12)
//            errorLabel.text = "There are not enough entries to draw a graph"
//            errorLabel.textColor = UIColor.black
//            errorLabel.isHidden = false
//            errorLabel.textAlignment = .center
//            
//            self.addSubview(errorLabel)
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        drawGraph()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        drawGraph()
    }
    
    
    
}

