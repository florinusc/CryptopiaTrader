//
//  TabBarController.swift
//  CryptopiaTrader
//
//  Created by Florin Uscatu on 9/29/17.
//  Copyright © 2017 Florin Uscatu. All rights reserved.
//

import UIKit

extension UINavigationController
{
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

class TabBarController: UITabBarController {

    let barColor = UIColor(red: 40/255, green: 43/255, blue: 53/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Customization for tab bar
        tabBar.barTintColor = barColor
        tabBar.tintColor = UIColor.white
        
        //Customization for the tab bar items
        if let tabBarItems = tabBar.items {
            tabBarItems[0].image = UIImage(named: "list")
            tabBarItems[0].title = "Coin List"
            tabBarItems[1].image = UIImage(named: "account")
            tabBarItems[1].title = "Account"
        }
        
        //Configure the login button
        let loginBttn = UIBarButtonItem(title: "Log in", style: .done, target: self, action: #selector(TabBarController.logIn))
        loginBttn.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = loginBttn
        
        //Configure the logo in the nav bar
        let logoImage = UIImage(named: "logoWhite")
        let logoImageView = UIImageView(image: logoImage)
        logoImageView.contentMode = UIViewContentMode.center
        self.navigationItem.titleView = logoImageView
        
        navigationController?.navigationBar.barTintColor = barColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        //Make the back button black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
    }
    
    @objc func logIn() {
        performSegue(withIdentifier: "loginSegue", sender: self)
    }

}
