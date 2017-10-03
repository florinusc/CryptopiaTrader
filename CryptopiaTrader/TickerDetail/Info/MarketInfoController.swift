//
//  MarketInfoController.swift
//  CryptopiaTrader
//
//  Created by Florin Uscatu on 9/26/17.
//  Copyright © 2017 Florin Uscatu. All rights reserved.
//

import UIKit

struct GetMarket: Decodable {
    var Success : Bool
    var Message: String?
    var Data : MarketInfo
}

struct MarketInfo: Decodable {
    var TradePairId: Int
    var Label: String
    var AskPrice: Double
    var BidPrice: Double
    var Low: Double
    var High: Double
    var Volume: Double
    var LastPrice: Double
    var BuyVolume: Double
    var SellVolume: Double
    var Change: Double
    var Open: Double
    var Close: Double
    var BaseVolume: Double
    var BaseBuyVolume: Double?
    var BaseSellVolume: Double?
}

class MarketInfoController: UITableViewController {

    var coinPair = String()
    var coinId = Int()
    
    var marketInfo: MarketInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if coinId != 0 {
            requestDataLocally(internalCoinId: coinId)
        }
        
    }
    //Requesting data from API
    func requestDataLocally(internalCoinId: Int) {
        ApiCalls().requestData(publicType: true, method: "GetMarket/\(internalCoinId)", parameters: [:]) { (data) in
            do {
                let tempInfo = try JSONDecoder().decode(GetMarket.self, from: data)
                self.marketInfo = tempInfo.Data
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let err {
                print(err)
            }
        }
        
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MarketInfoCell", for: indexPath) as! MarketInfoCell
        
        if let tempInfo:MarketInfo = marketInfo {
            switch indexPath.row {
            case 0:
                cell.descriptionLabel.text = "Last Price"
                cell.numberLabel.text = String(format: "%.8f", tempInfo.LastPrice)
            case 1:
                cell.descriptionLabel.text = "Change"
                cell.numberLabel.text = String(describing: tempInfo.Change) + "%"
                if tempInfo.Change < 0.0 {
                    cell.numberLabel.textColor = UIColor.red
                } else {
                    cell.numberLabel.textColor = UIColor(red: 81/255, green: 185/255, blue: 91/255, alpha: 1)
                }
            case 2:
                cell.descriptionLabel.text = "High"
                cell.numberLabel.text = String(format: "%.8f", tempInfo.High)
            case 3:
                cell.descriptionLabel.text = "Low"
                cell.numberLabel.text = String(format: "%.8f", tempInfo.Low)
            case 4:
                cell.descriptionLabel.text = "Volume"
                cell.numberLabel.text = String(format: "%.2f",tempInfo.Volume) + " BTC"
            default:
                break
            }
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "24 hour Statistics"
    }

}
