//
//  MarketTradeController.swift
//  CryptopiaTrader
//
//  Created by Florin Uscatu on 9/30/17.
//  Copyright © 2017 Florin Uscatu. All rights reserved.
//

import UIKit
import JSSAlertView

class MarketTradeController: UITableViewController {

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
    
    var coinPair = String()
    var coinId = Int()
    
    @IBOutlet weak var rateTxtFld: UITextField!
    @IBOutlet weak var amountTxtFld: UITextField!
    @IBOutlet weak var typeSegControlOutlet: UISegmentedControl!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBAction func typeSegControlAction(_ sender: UISegmentedControl) {
        let coinPairArr = coinPair.split(separator: "/")
        if sender.selectedSegmentIndex == 0 {
            sender.tintColor = UIColor(red: 81/255, green: 185/255, blue: 91/255, alpha: 1)
            requestBalance(coin: String(coinPairArr[1]))
        } else {
            sender.tintColor = UIColor.red
            requestBalance(coin: String(coinPairArr[0]))
            print("requesting: \(String(coinPairArr[0]))")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Customizing buttons
        calculateTotalBttnOutlet.layer.cornerRadius = 8.0
        placeOrderBttnOutlet.layer.cornerRadius = 8.0
        
        let coinPairArr = coinPair.split(separator: "/")
        
        //Setting up segment control
        if typeSegControlOutlet.selectedSegmentIndex == 0 {
            typeSegControlOutlet.tintColor = UIColor(red: 81/255, green: 185/255, blue: 91/255, alpha: 1)
            requestBalance(coin: String(coinPairArr[1]))
        } else {
            typeSegControlOutlet.tintColor = UIColor.red
            requestBalance(coin: String(coinPairArr[0]))
        }
        
        //Setting up text field delegate
        rateTxtFld.delegate = self
        amountTxtFld.delegate = self
    }
    
    var headerTitle = "Not logged in" {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var balance = 0.0
    
    func requestBalance(coin: String) {
        if key != "" && secret != "" {
            ApiCalls().requestData(publicType: false, method: "GetBalance", parameters: ["Currency" : coin], key: key, secret: secret) { (data) in
                do {
                    let tempArray = try JSONDecoder().decode(Balances.self, from: data)
                    if let balanceFromRequest = tempArray.Data[0] as? Balance {
                        self.headerTitle = "Balance: \(balanceFromRequest.Available) \(balanceFromRequest.Symbol)"
                        self.balance = balanceFromRequest.Available
                    }
                } catch let err {
                    print(err)
                    self.headerTitle = "Balance: 0 \(coin)"
                }
            }
        } else {
            JSSAlertView().danger(
                self,
                title: "Error",
                text: "Please log in before trying to place an order"
            )
        }
    }
    
    @IBOutlet weak var placeOrderBttnOutlet: UIButton!
    @IBAction func placeOrder(_ sender: UIButton) {
        if key != "" && secret != "" {
            if rateTxtFld.text != "" && amountTxtFld.text != "" {
                DispatchQueue.main.async {
                    guard let tradeType: String = self.typeSegControlOutlet.titleForSegment(at: self.typeSegControlOutlet.selectedSegmentIndex) else {return}
                    guard let amount: String = self.amountTxtFld.text else {return}
                    guard let rate: String = self.rateTxtFld.text else {return}
                    let alertview = JSSAlertView().show(
                        self,
                        title: "New Order",
                        text: "Are you sure you want to \(tradeType.lowercased()) \(amount) \(self.coinPair.split(separator: "/")[0]) at a rate of \(rate)?",
                        buttonText: "Yes",
                        cancelButtonText: "No" // This tells JSSAlertView to create a two-button alert
                    )
                    alertview.addAction(self.makeRequestToPlaceOrder)
                }

            } else {
                DispatchQueue.main.async {
                JSSAlertView().danger(
                    self,
                    title: "Error",
                    text: "Please insert values in the rate and amount fields"
                )
                }
            }
        } else {
            DispatchQueue.main.async {
            JSSAlertView().danger(
                self,
                title: "Error",
                text: "Please log in before trying to place an order"
            )
            }
        }
    }
    
    func makeRequestToPlaceOrder() {
        if let a = amountTxtFld.text, let r = rateTxtFld.text {
            if let inputAmount = Double(a), let inputRate = Double(r) {
                if inputAmount < self.balance {
                    
                    guard let tradeType: String = typeSegControlOutlet.titleForSegment(at: typeSegControlOutlet.selectedSegmentIndex) else {return}
                    
                    ApiCalls().requestData(publicType: false, method: "SubmitTrade", parameters: ["TradePairId" : coinId, "Type" : tradeType, "Rate" : inputRate, "Amount" : inputAmount], key: key, secret: secret, completionHandler: { (data) in
                        do {
                            let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSDictionary
                            print(jsonData)
                            let successResponse = jsonData["Success"] as? Int
                            if successResponse == 1 {
                                DispatchQueue.main.async {
                                    self.rateTxtFld.text = ""
                                    self.amountTxtFld.text = ""
                                    self.totalLabel.text = "-.-"
                                    JSSAlertView().show(
                                        self,
                                        title: "Success",
                                        text: "Your order has been placed successfully"
                                    )
                                }
                            } else {
                                DispatchQueue.main.async {
                                    JSSAlertView().danger(
                                        self,
                                        title: "Error",
                                        text: "Your order could not be placed, please try again later"
                                    )
                                }
                            }
                        } catch let err {
                            print(err)
                        }
                    })
                    
                } else {
                    DispatchQueue.main.async {
                        JSSAlertView().danger(
                            self,
                            title: "Error",
                            text: "Insufficient funds"
                        )
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                JSSAlertView().danger(
                    self,
                    title: "Error",
                    text: "Invalid input"
                )
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerTitle
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let coin = coinPair.split(separator: "/")[1]
        if let a = amountTxtFld.text, let r = rateTxtFld.text {
            if let amount = Double(a), let rate = Double(r) {
                totalLabel.text = String(amount*rate) + " " + coin
            }
        }
    }
    
    
    @IBOutlet weak var calculateTotalBttnOutlet: UIButton!
    @IBAction func calculateTotal(_ sender: UIButton) {
        view.endEditing(true)
        let coin = coinPair.split(separator: "/")[1]
        if let a = amountTxtFld.text, let r = rateTxtFld.text {
            if let amount = Double(a), let rate = Double(r) {
                totalLabel.text = String(amount*rate) + " " + coin
            }
        }
    }
    
}

extension MarketTradeController: UITextFieldDelegate {
    
    //this prohibits the user from typing in letters in the fields
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = "0123456789."
        return allowedCharacters.contains(string) || range.length == 1
    }
    
}
