//
//  PageMenuController.swift
//  CryptopiaTrader
//
//  Created by Florin Uscatu on 9/25/17.
//  Copyright © 2017 Florin Uscatu. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ContainerForPageMenuController: UIViewController {
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    var coinPair = String()
    var coinId = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set title
        self.title = coinPair
        
        //Setup for banner view
        //the real adUnitID is: ca-app-pub-9882773070772556/1173868841
        
        bannerView.adUnitID = "ca-app-pub-9882773070772556/1173868841"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
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
