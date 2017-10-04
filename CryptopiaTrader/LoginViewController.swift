//
//  LoginViewController.swift
//  CryptopiaTrader
//
//  Created by Florin Uscatu on 9/29/17.
//  Copyright © 2017 Florin Uscatu. All rights reserved.
//

import UIKit
import JSSAlertView

class LoginViewController: UIViewController {

    @IBOutlet weak var keyTxtfld: UITextField!
    @IBOutlet weak var secretTxtfld: UITextField!
    
    @IBAction func cancelBttn(_ sender: UIButton) {
        
        //go back to the tab controller
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginBttnOutlet.layer.cornerRadius = 8.0
        
        if UserDefaults.standard.value(forKey: "key") != nil && UserDefaults.standard.value(forKey: "secret") != nil {
            loginBttnOutlet.setTitle("Update", for: .normal)
        } else {
            loginBttnOutlet.setTitle("Log in", for: .normal)
        }
        
    }
    
    @IBOutlet weak var loginBttnOutlet: UIButton!
    @IBAction func loginBttn(_ sender: UIButton) {
        
        if !(keyTxtfld.text?.isEmpty)! && !(secretTxtfld.text?.isEmpty)! {
            
            //Save the key and secret in userdefaults, so the user doesn't have to copy them in the app everytime they open it
            UserDefaults.standard.set(keyTxtfld.text, forKey: "key")
            UserDefaults.standard.set(secretTxtfld.text, forKey: "secret")
            
            self.dismiss(animated: true, completion: nil)
            
        } else {
            //in case the textfields are empty the user will get an alert
            JSSAlertView().show(
                self,
                title: "Alert",
                text: "Please copy over the key and secret into the text fields",
                buttonText: "Ok"
            )
        }
        
    }
}
