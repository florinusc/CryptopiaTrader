//
//  AccountTradesViewController.swift
//  CryptopiaTrader
//
//  Created by Florin Uscatu on 9/29/17.
//  Copyright © 2017 Florin Uscatu. All rights reserved.
//

import UIKit
import JSSAlertView
import CryptoSwift

struct Trades: Decodable {
    var Data: [Trade]
    var Error: String?
    var Success: Int
}

struct Trade: Decodable {
    var Amount: Double
    var Market: String
    var Rate: Double
    var TimeStamp: String
    var Total: Double
    var `Type`: String
}


class AccountTradesViewController: UITableViewController {

    var tradesArray: [Trade] = []
    
    @objc let tradesRefreshControl = UIRefreshControl()
    
    //getting the key
    var key: String {
        if UserDefaults.standard.value(forKey: "key") != nil {
            return UserDefaults.standard.value(forKey: "key") as! String
        } else {
            print("there is no key")
            return ""
        }
    }
    
    //getting the secret
    var secret: String {
        if UserDefaults.standard.value(forKey: "secret") != nil {
            return UserDefaults.standard.value(forKey: "secret") as! String
        } else {
            print("there is no secret")
            return ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup for refresh control
        tradesRefreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        tradesRefreshControl.addTarget(self, action: #selector(AccountTradesViewController.refresh), for: .allEvents)
        tableView.refreshControl = tradesRefreshControl
    }
    
    //Refresh the tableView when selector is triggered
    @objc func refresh() {
        requestDataLocally()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        requestDataLocally()
    }
    
    func requestDataLocally() {
        if key != "" && secret != "" {
            ApiCalls().requestData(publicType: false, method: "GetTradeHistory", parameters: [:], key: key, secret: secret) { (data) in
                do {
                    let tempArray = try JSONDecoder().decode(Trades.self, from: data)
                    self.tradesArray = tempArray.Data
                    DispatchQueue.main.async {
                        self.tradesRefreshControl.endRefreshing()
                        self.tableView.reloadData()
                    }
                } catch let err {
                    self.tradesRefreshControl.endRefreshing()
                    print(err)
                }
            }
        } else {
            DispatchQueue.main.async {
                self.tradesRefreshControl.endRefreshing()
                JSSAlertView().danger(
                    self,
                    title: "Log in",
                    text: "Please log in to see trades"
                )
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
        var numberOfRows: Int = 0
        let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        let emptyView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        noDataLabel.textAlignment = .center
        noDataLabel.textColor = UIColor.black
        
        if key != "" && secret != "" {
            if tradesArray.count > 0 {
                numberOfRows = tradesArray.count
                tableView.backgroundView = emptyView
                tableView.separatorStyle = .singleLine
            } else {
                noDataLabel.text = "No data to show"
                tableView.separatorStyle = .none
                tableView.backgroundView = noDataLabel
            }
        } else {
            noDataLabel.text = "Please log in to see orders"
            tableView.separatorStyle = .none
            tableView.backgroundView = noDataLabel
        }
        return numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tradeCell", for: indexPath) as! TradeCell
        
        let dateString = tradesArray[indexPath.row].TimeStamp.split(separator: "T")
        let datePart = dateString[0]
        let timePart = dateString[1].split(separator: ".")
        let timeWithoutSecondsPart = timePart[0]
        let finalDateString:String = datePart + " " + timeWithoutSecondsPart
        
        cell.amount.text = "Amount: " + String(tradesArray[indexPath.row].Amount)
        cell.market.text = tradesArray[indexPath.row].Market
        cell.date.text = finalDateString
        cell.rate.text = "Rate: " + String(format: "%.8f", tradesArray[indexPath.row].Rate)
        cell.total.text = "Total: " + String(format: "%.8f", tradesArray[indexPath.row].Total)
        cell.type.text = tradesArray[indexPath.row].Type
        
        switch tradesArray[indexPath.row].Type {
        case "Buy":
            cell.type.textColor = UIColor(red: 81/255, green: 185/255, blue: 91/255, alpha: 1)
        case "Sell":
            cell.type.textColor = UIColor.red
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
