//
//  Keychain.swift
//  rentalsystems
//
//  Created by Azra Mesic on 15/02/2019.
//  Copyright © 2019 Azra Mesic. All rights reserved.
//
import UIKit

open class Keychain {
    
    open class func set(_ key: String, value: String) -> Bool {
        let query : [NSString : AnyObject] = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrService : "mba" as AnyObject,
            kSecAttrLabel : ("mba" + key) as AnyObject,
            kSecAttrAccount : key as AnyObject,
            kSecValueData : value.data(using: String.Encoding.utf8)! as AnyObject
        ]
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
        return true
    }
    
    open class func get(_ key: String) -> NSString? {
        let data = getData(key)
        if (data != nil) {
            return data
        }
        
        return nil
    }
    
    open class func getData(_ key: String) -> NSString? {
        let query : [NSString : AnyObject] = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrService : "mba" as AnyObject,
            kSecReturnAttributes : true as AnyObject,
            kSecReturnData : true as AnyObject,
            kSecAttrAccount : key as AnyObject
        ]
        var result : AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if (status == errSecSuccess) {
            if let result = result as? [NSString : AnyObject],
                let resultData = result[kSecValueData] as? Data,
                let resultString = NSString(data:resultData, encoding:String.Encoding.utf8.rawValue) {
                    return (resultString)
            }
        } else if (status == errSecItemNotFound) {
            return nil;
        }
        
        return nil
    }
    
}
