//
//  ViewController.swift
//  CryptopiaTrader
//
//  Created by Florin Uscatu on 9/25/17.
//  Copyright © 2017 Florin Uscatu. All rights reserved.
//

import UIKit

struct Market: Decodable {
    var Data: [TradePair]
    var Error: String?
    var Message: String?
    var Success: Int
}

struct TradePair: Decodable {
    
    var TradePairId : Int
    var Label : String
    var AskPrice: Double
    var BidPrice: Double
    var Low : Double
    var High: Double
    var Volume : Double
    var LastPrice : Double
    var BuyVolume : Double
    var SellVolume : Double
    var Change : Double
    var Open : Double
    var Close : Double
    var BaseVolume : Double
    var BaseBuyVolume : Double?
    var BaseSellVolume : Double?
    
}

class TickerViewController: UITableViewController {
    
    var pairArray: [TradePair] = []
    var defaultMarket:String = "BTC"
    var defaultSort:String = "Coin"
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set title
        self.title = "Cryptopia"        
        
        // Request the data for the first time
        requestDataLocally(sortedBy: "Coin")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Timer used to refresh the data in the table
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(TickerViewController.reloadAtInterval), userInfo: nil, repeats: true)
    }
    
    @objc func reloadAtInterval() {
        requestDataLocally(sortedBy: defaultSort)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        timer.invalidate()
    }

    
    @IBAction func marketSelectorSegmentControl(_ sender: UISegmentedControl) {
        //Set the chosen coin pair
        switch sender.selectedSegmentIndex {
        case 0:
            defaultMarket = "BTC"
        case 1:
            defaultMarket = "USDT"
        case 2:
            defaultMarket = "NZDT"
        case 3:
            defaultMarket = "LTC"
        case 4:
            defaultMarket = "DOGE"
        default:
            break
        }
        requestDataLocally(sortedBy: defaultSort)
    }
    
    var sortAscendingCoin = false
    var sortAscendingVolume = false
    var sortAscendingChange = false
    var sortAscendingPrice = false
    
    @IBAction func sortByCoin(_ sender: UIButton) {
        sortAscendingCoin = !sortAscendingCoin
        defaultSort = "Coin"
    }
    
    @IBAction func sortByVolume(_ sender: UIButton) {
        sortAscendingVolume = !sortAscendingVolume
        defaultSort = "Volume"
    }
    
    @IBAction func sortByChange(_ sender: UIButton) {
        sortAscendingChange = !sortAscendingChange
        defaultSort = "Change"
    }
    
    @IBAction func sortByPrice(_ sender: UIButton) {
        sortAscendingPrice = !sortAscendingPrice
        defaultSort = "Price"
    }
    
    //Requesting data from API
    @objc func requestDataLocally(sortedBy: String) {
    
        ApiCalls().requestData(publicType: true, method: "GetMarkets", parameters: [:]) { (data) in
            do {
                let tempArray = try JSONDecoder().decode(Market.self, from: data)
                
                switch self.defaultSort {
                case "Coin":
                    if self.sortAscendingPrice == true {
                        self.pairArray = tempArray.Data.filter {$0.Label.split(separator: "/")[1] == self.defaultMarket}.sorted {$0.Label > $1.Label}
                    } else {
                        self.pairArray = tempArray.Data.filter {$0.Label.split(separator: "/")[1] == self.defaultMarket}.sorted {$0.Label < $1.Label}
                    }
                case "Volume":
                    if self.sortAscendingVolume == true {
                        self.pairArray = tempArray.Data.filter {$0.Label.split(separator: "/")[1] == self.defaultMarket}.sorted {$0.Volume > $1.Volume}
                    } else {
                        self.pairArray = tempArray.Data.filter {$0.Label.split(separator: "/")[1] == self.defaultMarket}.sorted {$0.Volume < $1.Volume}
                    }
                case "Change":
                    if self.sortAscendingChange == true {
                        self.pairArray = tempArray.Data.filter {$0.Label.split(separator: "/")[1] == self.defaultMarket}.sorted {$0.Change > $1.Change}
                    } else {
                        self.pairArray = tempArray.Data.filter {$0.Label.split(separator: "/")[1] == self.defaultMarket}.sorted {$0.Change < $1.Change}
                    }
                case "Price":
                    if self.sortAscendingPrice == true {
                        self.pairArray = tempArray.Data.filter {$0.Label.split(separator: "/")[1] == self.defaultMarket}.sorted {$0.LastPrice > $1.LastPrice}
                    } else {
                        self.pairArray = tempArray.Data.filter {$0.Label.split(separator: "/")[1] == self.defaultMarket}.sorted {$0.LastPrice < $1.LastPrice}
                    }
                default:
                    break
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let err {
                print(err)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pairArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TickerCell", for: indexPath) as? TickerCell else {return UITableViewCell()}
        
        //Setting the labels of the cells
        cell.changeLabel.text = String(pairArray[indexPath.row].Change) + "%"
        cell.priceLabel.text = String(format: "%.8f", pairArray[indexPath.row].LastPrice)
        cell.tickerLabel.text = String(pairArray[indexPath.row].Label.split(separator: "/")[0])
        cell.volumeLabel.text = String(format: "%.2f", pairArray[indexPath.row].Volume)
        
        if pairArray[indexPath.row].Change < 0 {
            cell.changeLabel.textColor = UIColor.red
        } else {
            cell.changeLabel.textColor = UIColor(red: 81/255, green: 185/255, blue: 91/255, alpha: 1)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    @IBOutlet var extraView: UIView!
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return extraView
    }
    
    //Variable created in order to pass the coin pair to the next view controller
    var selectedCoinPair = ""
    var selectedCoinId = 0
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCoinPair = pairArray[indexPath.row].Label
        selectedCoinId = pairArray[indexPath.row].TradePairId
        performSegue(withIdentifier: "goToCoin", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCoin" {
            let destinationVC = segue.destination as? ContainerForPageMenuController
            destinationVC?.coinPair = selectedCoinPair
            destinationVC?.coinId = selectedCoinId
        }
    }
    
}

