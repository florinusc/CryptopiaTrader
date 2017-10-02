//
//  File.swift
//  CryptopiaTrader
//
//  Created by Florin Uscatu on 9/26/17.
//  Copyright © 2017 Florin Uscatu. All rights reserved.
//

import UIKit
import Parchment


class PageMenuControllerForTicker: UIViewController {

    var coinPair = String()
    var coinId = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var controllerArray : [UIViewController] = []

        let infoViewController : MarketInfoController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MarketInfo") as! MarketInfoController
        infoViewController.coinPair = coinPair
        infoViewController.coinId = coinId
        infoViewController.title = "Info"
        controllerArray.append(infoViewController)
        
        let chartsViewController : MarketChartController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MarketChart") as! MarketChartController
        chartsViewController.coinPair = coinPair
        chartsViewController.coinId = coinId
        chartsViewController.title = "Chart"
        controllerArray.append(chartsViewController)
        
        let tradeViewController : MarketTradeController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MarketTrade") as! MarketTradeController
        tradeViewController.coinPair = coinPair
        tradeViewController.coinId = coinId
        tradeViewController.title = "Trade"
        controllerArray.append(tradeViewController)
        
        let ordersViewController : MarketOrdersViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MarketOrdersViewController") as! MarketOrdersViewController
        ordersViewController.coinPair = coinPair
        ordersViewController.coinId = coinId
        ordersViewController.title = "Orders"
        controllerArray.append(ordersViewController)
        
        let tradesViewController : MarketTradesViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MarketTradesViewController") as! MarketTradesViewController
        tradesViewController.coinPair = coinPair
        tradesViewController.coinId = coinId
        tradesViewController.title = "Trades"
        controllerArray.append(tradesViewController)

        let pagingViewController = FixedPagingViewController(viewControllers: controllerArray)
        
        // Make sure you add the PagingViewController as a child view
        // controller and contrain it to the edges of the view.
        addChildViewController(pagingViewController)
        view.addSubview(pagingViewController.view)
        view.constrainToEdges(pagingViewController.view)
        pagingViewController.didMove(toParentViewController: self)
    }
}

