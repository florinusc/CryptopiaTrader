//
//  AccountContainerForPageMenuController.swift
//  CryptopiaTrader
//
//  Created by Florin Uscatu on 9/27/17.
//  Copyright © 2017 Florin Uscatu. All rights reserved.
//

import UIKit
import Parchment

class AccountPageMenuControllerForTicker: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var controllerArray : [UIViewController] = []
        
        let balancesViewController : AccountBalanceViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AccountBalanceViewController") as! AccountBalanceViewController
        balancesViewController.title = "Balances"
        controllerArray.append(balancesViewController)
        
        let tradesViewController : AccountTradesViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AccountTradesViewController") as! AccountTradesViewController
        tradesViewController.title = "Trades"
        controllerArray.append(tradesViewController)
        
        let ordersViewController : AccountOrdersViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AccountOrdersViewController") as! AccountOrdersViewController
        ordersViewController.title = "Orders"
        controllerArray.append(ordersViewController)
        
        let pagingViewController = FixedPagingViewController(viewControllers: controllerArray)
        
        // Make sure you add the PagingViewController as a child view
        // controller and contrain it to the edges of the view.
        addChildViewController(pagingViewController)
        view.addSubview(pagingViewController.view)
        view.constrainToEdges(pagingViewController.view)
        pagingViewController.didMove(toParentViewController: self)
    }
    

        
}
