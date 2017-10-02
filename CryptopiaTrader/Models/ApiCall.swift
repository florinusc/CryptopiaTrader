//
//  ApiCall.swift
//  CryptopiaTrader
//
//  Created by Florin Uscatu on 9/30/17.
//  Copyright © 2017 Florin Uscatu. All rights reserved.
//

import Foundation

struct ApiCalls {

    func requestData(publicType: Bool, method: String, parameters: [String:Any], key: String? = nil, secret: String? = nil, completionHandler: @escaping (_ data: Data) -> ()) {
        
        if !publicType {
            //Requesting data from private API
            let timeNowInt = Int((NSDate().timeIntervalSince1970)*500000)
            let nonce = String(timeNowInt)
            
            if key != "" && secret != "" {
                //URL that will be used
                let urlString = "https://www.cryptopia.co.nz/api/" + method
                guard let url = URL(string: urlString) else {return}
                let sigUrl = urlString.replacingOccurrences(of: ":", with: "%3a").replacingOccurrences(of: "/", with: "%2f").lowercased()
                
                var parameterString = "{}"
                
                do {
                    let json = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                    parameterString = String(data: json, encoding: .utf8)!
                } catch let err {
                    print(err)
                }
                
                let base64EncodedMd5ofParams = (parameterString).toMd5Data().base64EncodedString()
                
                let signature = key! + "POST" + sigUrl + nonce + base64EncodedMd5ofParams
                let hmacSignature = signature.hmacy(algorithm: .SHA256, key: secret!)
                let requestSignaturePart1 = "amx " + key! + ":"
                let requestSignaturePart2 =  hmacSignature + ":" + nonce
                
                let requestSignature = requestSignaturePart1 + requestSignaturePart2
                
                //setting up the reguest
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.httpBody = parameterString.data(using: .utf8)
                request.setValue(requestSignature, forHTTPHeaderField: "Authorization")
                request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                
                //starting the url session
                let task = URLSession.shared.dataTask(with: request) {
                    (data, response, error) -> Void in
                    
                    if error == nil {
                        do {
                            if data != nil {
                                completionHandler(data!)
                            }
                        }
                    } else {
                        print(error as Any)
                    }
                }
                task.resume()
            } else {
                print("can't show balances because the key and secret are nil")
            }
        } else {
            //Requesting data from public API
            print("reuqesting data from public API")
            let urlString = "https://www.cryptopia.co.nz/api/" + method
            guard let url = URL(string: urlString) else {return}
            URLSession.shared.dataTask(with: url) {
                data,response,error in
                if error == nil {
                    if data != nil {
                        do {
                            completionHandler(data!)
                        }
                    }
                }
            }.resume()
        }
    }
}
