//
//  ChartCell.swift
//  CryptopiaTrader
//
//  Created by Florin Uscatu on 11/14/17.
//  Copyright © 2017 Florin Uscatu. All rights reserved.
//

import UIKit


class ChartCell: UITableViewCell {

    var graphView = GraphView()
    
    var denomination: String?
    var chartPeriod: Int?
    
    var graphData: [ChartData]? {
        didSet {
                if denomination != nil && chartPeriod != nil && graphData != nil {
                    
                    graphView.removeFromSuperview()
                    
                    graphView = GraphView(frame: CGRect(x: 0, y: 0, width: self.contentView.bounds.width, height: 300))
                    graphView.denomination = denomination!
                    graphView.chartPeriod = chartPeriod
                    graphView.graphData = graphData!
                    
                    self.addSubview(graphView)
                    
                } else {
                    print("something is missing, can't draw graph")
                }
        }
    }
    
    override func awakeFromNib() {
        // Stylize the cell
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }

}
