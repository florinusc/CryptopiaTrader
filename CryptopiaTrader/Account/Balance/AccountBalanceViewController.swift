//
//  AccountBalanceViewController.swift
//  CryptopiaTrader
//
//  Created by Florin Uscatu on 9/27/17.
//  Copyright © 2017 Florin Uscatu. All rights reserved.
//

import UIKit
import CryptoSwift
import JSSAlertView

struct Balances: Decodable {
    var Data: [Balance]
    var Error: String?
    var Success: Int
}

struct Balance: Decodable {
    var Symbol: String
    var Available: Double
    var Total: Double
    var Unconfirmed: Double
    var HeldForTrades: Double
    var PendingWithdraw: Double
}

class AccountBalanceViewController: UITableViewController {
    
    var balanceArray: [Balance] = []
    
    @objc let balanceRefreshControl = UIRefreshControl()
    
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
        balanceRefreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        balanceRefreshControl.addTarget(self, action: #selector(AccountBalanceViewController.refresh), for: .allEvents)
        tableView.refreshControl = balanceRefreshControl
    }
    
    //Refresh the tableView when selector is triggered
    @objc func refresh() {
        requestDataLocally()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        requestDataLocally()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        balanceRefreshControl.endRefreshing()
    }
    
    func requestDataLocally() {
        ApiCalls().requestData(publicType: false, method: "GetBalance", parameters: [:], key: key, secret: secret) { (data) in
            do {
                let tempArray = try JSONDecoder().decode(Balances.self, from: data)
                self.balanceArray = tempArray.Data.filter {$0.Total > 0.0}
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.balanceRefreshControl.endRefreshing()
                }
            } catch let err {
                print(err)
                self.balanceRefreshControl.endRefreshing()
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
        return balanceArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "balanceCell", for: indexPath) as! BalanceCell
        if balanceArray.count > 0 {
            cell.available.text = "Available: " + String(balanceArray[indexPath.row].Available)
            cell.total.text = "Total: " + String(balanceArray[indexPath.row].Total)
            cell.pendingWithdraw.text = "Pending Withdraw: " + String(balanceArray[indexPath.row].PendingWithdraw)
            cell.unconfirmed.text = "Unconfirmed: " +  String(balanceArray[indexPath.row].Unconfirmed)
            cell.heldForTrades.text = "Held for Trades: " + String(balanceArray[indexPath.row].HeldForTrades)
            cell.coinName.text = balanceArray[indexPath.row].Symbol
        } else {
            cell.coinName.text = "No balance to show"
            cell.available.text = ""
            cell.total.text = ""
            cell.pendingWithdraw.text = ""
            cell.unconfirmed.text = ""
            cell.heldForTrades.text = ""
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

}
