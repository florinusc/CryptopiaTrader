//
//  BalanceCell.swift
//  CryptopiaTrader
//
//  Created by Florin Uscatu on 9/29/17.
//  Copyright © 2017 Florin Uscatu. All rights reserved.
//

import UIKit

class BalanceCell: UITableViewCell {
    @IBOutlet weak var pendingWithdraw: UILabel!
    @IBOutlet weak var heldForTrades: UILabel!
    @IBOutlet weak var unconfirmed: UILabel!
    @IBOutlet weak var available: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var coinName: UILabel!
}
