//
//  PageMenuController.swift
//  CryptopiaTrader
//
//  Created by Florin Uscatu on 9/25/17.
//  Copyright © 2017 Florin Uscatu. All rights reserved.
//

import UIKit

class ContainerForPageMenuController: UIViewController {
    
    var coinPair = String()
    var coinId = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set title
        self.title = coinPair
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "containerSegue" {
            let pageViewController = segue.destination as! PageMenuControllerForTicker
            pageViewController.coinPair = coinPair
            pageViewController.coinId = coinId
            
            print("sending these to page menu controller: \(coinPair) \(coinId)")
            
        }
    }

}
