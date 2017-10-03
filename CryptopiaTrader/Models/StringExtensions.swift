//
//  StringExtensions.swift
//  CryptopiaTrader
//
//  Created by Florin Uscatu on 9/29/17.
//  Copyright © 2017 Florin Uscatu. All rights reserved.
//

import Foundation

extension String {
    
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    
    func digest(algorithm: CustomHMACAlgorithm, key: String) -> String! {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = UInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = algorithm.digestLength()
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        let keyStr = key.cString(using: String.Encoding.utf8)
        let keyLen = UInt(key.lengthOfBytes(using: String.Encoding.utf8))
        
        CCHmac(algorithm.toCCEnum(), keyStr!, Int(keyLen), str!, Int(strLen), result)
        let data = NSData(bytesNoCopy: result, length: digestLen)
        result.deinitialize()
        
        return data.base64EncodedString()
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    func base64Decoded() -> String? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) {
            //let red = data.base64EncodedString()
            let datastring = NSString(data: data, encoding: String.Encoding.ascii.rawValue)
            return datastring as String?
        }
        return nil
    }
    
    func hmacy(algorithm: CustomHMACAlgorithm, key: String) -> String {
        let cKey = key.base64DecodeAsData();
        let cData = self.cString(using: String.Encoding.utf8)
        var result = [CUnsignedChar](repeating: 0, count: Int(algorithm.digestLength()))
        let strLen = Int(strlen(cData!))
        CCHmac(algorithm.toCCEnum(), cKey.bytes, cKey.length, cData!, strLen, &result)
        let hmacData:NSData = NSData(bytes: result, length: (Int(algorithm.digestLength())))
        let hmacBase64 = hmacData.base64EncodedString(options: .lineLength76Characters)
        return String(hmacBase64)
    }
    
    func base64DecodeAsData() -> NSData {
        let decodedData = NSData(base64Encoded: self, options: NSData.Base64DecodingOptions(rawValue: 0))
        return decodedData!
    }
    
    func toMd5Data() -> NSData {
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        if let data = self.data(using: String.Encoding.utf8) {
            CC_MD5(data.bytes, CC_LONG(data.count), &digest)
        }
        
        let digestData = NSData(bytes: digest, length: Int(CC_MD5_DIGEST_LENGTH))
        
        return digestData
    }
    
}
