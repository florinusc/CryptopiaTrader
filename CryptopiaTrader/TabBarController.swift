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
        
        //Customization for tab bar
        tabBar.barTintColor = UIColor.black
        tabBar.tintColor = UIColor.white
        
        //Customization for the tab bar items
        if let tabBarItems = tabBar.items {
            tabBarItems[0].image = UIImage(named: "smallHive")
            tabBarItems[0].title = "Coin List"
            tabBarItems[1].image = UIImage(named: "account")
            tabBarItems[1].title = "Account"
        }
        
        //Configure the login button
        let loginBttn = UIBarButtonItem(title: "Log in", style: .done, target: self, action: #selector(TabBarController.logIn))
        loginBttn.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = loginBttn
        
        //Configure the logo in the nav bar
        let logoImage = UIImage(named: "logo")
        let logoImageView = UIImageView(image: logoImage)
        logoImageView.contentMode = UIViewContentMode.scaleAspectFit
        self.navigationItem.titleView = logoImageView
        
        //Make the back button black
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
    }
    
    @objc func logIn() {
        performSegue(withIdentifier: "loginSegue", sender: self)
    }

}
