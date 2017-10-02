//
//  TabBarController.swift
//  CryptopiaTrader
//
//  Created by Florin Uscatu on 9/29/17.
//  Copyright © 2017 Florin Uscatu. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginBttn = UIBarButtonItem(title: "Log in", style: .done, target: self, action: #selector(TabBarController.logIn))
        
        self.navigationItem.leftBarButtonItem = loginBttn
    }
    
    @objc func logIn() {
        performSegue(withIdentifier: "loginSegue", sender: self)
    }

}
