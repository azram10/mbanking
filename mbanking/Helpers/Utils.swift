//
//  Utils.swift
//  mbanking
//
//  Created by Azra Mesic on 15/02/2019.
//  Copyright © 2019 Azra Mesic. All rights reserved.
//

import UIKit
import CommonCrypto

class Utils: NSObject {
    
    class func formatDate(_ dateString : String, fromFormat : String, toFormat : String, setLocale: Bool? = false, timezone: String? = nil) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        if setLocale != nil && setLocale == true {
            dateFormatter.locale = Locale(identifier: "en")
        }
        
        if let date:Date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = toFormat
            if timezone != nil {
                dateFormatter.timeZone = TimeZone(identifier: timezone!)
            }
            let formatedDateString = dateFormatter.string(from: date)
            
            return formatedDateString
        }
        
        return ""
    }
    
    class func dateFromString(_ dateString : String, fromFormat : String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        
        if let date = dateFormatter.date(from: dateString) {
            return date
        }
        return nil
    }
    
    class func stringFromDate(_ date: Date?, toFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = toFormat
        if date != nil {
            return dateFormatter.string(from: date!)
        }
        return ""
    }
    
    static func MD5(_ string: String) -> String? {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)
        
        if let d = string.data(using: String.Encoding.utf8) {
            _ = d.withUnsafeBytes { (body: UnsafePointer<UInt8>) in
                CC_MD5(body, CC_LONG(d.count), &digest)
            }
        }
        
        return (0..<length).reduce("") {
            $0 + String(format: "%02x", digest[$1])
        }
    }
}
