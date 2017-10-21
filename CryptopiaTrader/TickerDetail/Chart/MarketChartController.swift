//
//  MarketChartController.swift
//  CryptopiaTrader
//
//  Created by Florin Uscatu on 9/26/17.
//  Copyright © 2017 Florin Uscatu. All rights reserved.
//

import UIKit

class MarketChartController: UITableViewController {

    var chartData: [ChartData] = []
    
    var coinPair = String()
    var coinId = Int()
    var denomination = String()
    
    let periods = [15, 30, 60, 120, 240, 720, 1440]
    var chartPeriod = 1440
    
    let spans = [1, 2, 7, 14, 30, 90]
    //default span of one month in 1 day increments
    var numberOfEntries = 30
    
    @IBOutlet var footerView: UIView!
    
    @IBOutlet weak var timeFrameSegCtrl: UISegmentedControl!
    
    @IBAction func timeFrameSegCtrlAction(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        chartPeriod = periods[selectedIndex]
        
    }
    
    @IBOutlet weak var timeSpanSegCtrl: UISegmentedControl!
    @IBAction func timeSpanSegCtrlAction(_ sender: UISegmentedControl) {
    }
    
    
    @IBOutlet weak var buildChartBttnOutlet: UIButton!
    @IBAction func buildChartBttn(_ sender: UIButton) {
        
        let selectedSpan = spans[timeSpanSegCtrl.selectedSegmentIndex]
        
        let denominator = 1440 / chartPeriod
        
        numberOfEntries = selectedSpan * denominator
        
        print("number of entries: \(numberOfEntries)")
        requestData(internalCoinId: coinId, timeFrame: chartPeriod)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildChartBttnOutlet.layer.cornerRadius = 8.0
        
        requestData(internalCoinId: coinId, timeFrame: 1440)
        denomination = String(coinPair.split(separator: "/")[1])
    }

    //Requesting data from API
    @objc func requestData(internalCoinId: Int, timeFrame: Int) {
        print("requesting data for market: \(internalCoinId)")
        guard let url = URL(string: "https://www.cryptopia.co.nz/Exchange/GetTradePairChart?tradePairId=\(internalCoinId)&dataRange=2&dataGroup=\(timeFrame)") else {return}
        URLSession.shared.dataTask(with: url) {
            data,response,error in
            if error == nil {
                if data != nil {
                    do {
                        let jsonData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                        DispatchQueue.main.async {
                        self.chartData.removeAll()
                        if let candleData = jsonData.value(forKey: "Candle") as? NSArray {
                            
                            for entry in candleData {
                                if let item = entry as? NSArray {
                                    self.chartData.append(ChartData(date: item[0] as! Int,
                                                               high: item[2] as! Double,
                                                               low: item[3] as! Double,
                                                               open: item[1] as! Double,
                                                               close: item[4] as! Double))
                                }
                            }
                        }
                        
                        
                            self.tableView.reloadData()
                        }
                        
                    } catch let err {
                        print(err)
                    }
                }
            }
            }.resume()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 300
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        // Stylize cell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        
        for subview in cell.subviews {
            subview.removeFromSuperview()
        }
        
        let graphView = GraphView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 300))
        graphView.chartPeriod = chartPeriod
        graphView.denomination = denomination
        print("passing the following chart period: \(chartPeriod)")
        graphView.graphData = Array(chartData.suffix(numberOfEntries))
        
        cell.addSubview(graphView)

        cell.selectionStyle = .none
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
}
