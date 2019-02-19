//
//  RequestManager.swift
//  mbanking
//
//  Created by Azra Mesic on 15/02/2019.
//  Copyright © 2019 Azra Mesic. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Transaction: JSONable {
    var amount: String
    var id: Int
    var date: Date?
    var description: String
    var type: String?
    
    required init(parameter: JSON) {
        id = Int(parameter["id"].stringValue) ?? 0
        amount = parameter["amount"].stringValue
        date = Utils.dateFromString(parameter["date"].string ?? "", fromFormat: "dd.MM.yyyy.")
        description = parameter["description"].stringValue
        type = parameter["type"].stringValue
    }
}

class AccountMapper: JSONable {
    var id: Int
    var iban: String
    var amount: String
    var currency: String
    var transactions: [Transaction]
    
    required init(parameter: JSON) {
        id = Int(parameter["id"].stringValue) ?? 0
        iban = parameter["IBAN"].string ?? ""
        amount = parameter["amount"].string ?? ""
        currency = parameter["currency"].string ?? ""
        transactions = parameter["transactions"].to(type: Transaction.self) as! [Transaction]
    }
}

struct Account {
    var id: Int
    var iban: String
    var amount: String
    var currency: String
    var transactions: [Date: [Transaction]]
    
    init(account: AccountMapper) {
        id = account.id
        iban = account.iban
        amount = account.amount
        currency = account.currency
        
        var filteredTransactions = account.transactions.filter { $0.date != nil }
        filteredTransactions.sort(by: { $0.date! > $1.date! })
        var accountTransactions = [Date: [Transaction]]()
        for transaction in account.transactions {
            let date = Utils.dateFromString(Utils.stringFromDate(transaction.date, toFormat: "MM.yyyy"), fromFormat: "MM.yyyy")!
           
            if accountTransactions[date] != nil {
                accountTransactions[date]!.append(transaction)
            } else {
                accountTransactions[date] = [transaction]
            }
        }
        transactions = accountTransactions
    }
}

protocol JSONable {
    init?(parameter: JSON)
}

class RequestManager: NSObject {
    
    static func getData(completionHandler: @escaping ([Int: Account]?, Error?) -> ()) {
        var data = [Int: Account]()
        
        Alamofire.request("http://mobile.asseco-see.hr/builds/ISBD_public/Zadatak_1.json").validate().responseJSON { response in
            switch response.result {
            case .success:
                let responseData = JSON(response.result.value!)
                
                guard let parsedData = responseData["acounts"].to(type: AccountMapper.self), let accounts = parsedData as? [AccountMapper]  else {
                    completionHandler(nil, NSError(domain: "", code: NSURLErrorBadServerResponse
, userInfo: nil))
                    return
                }
                for account in accounts.reversed() {
                    data[account.id] = Account(account: account)
                }
                completionHandler(data, nil)
            case .failure(let error):
                completionHandler(nil, error as NSError)
            }
        }
    }
}

extension JSON {
    func to<T>(type: T?) -> Any? {
        if let baseObj = type as? JSONable.Type {
            if self.type == .array {
                var arrObject: [Any] = []
                for obj in self.arrayValue {
                    let object = baseObj.init(parameter: obj)
                    arrObject.append(object!)
                }
                return arrObject
            } else {
                let object = baseObj.init(parameter: self)
                return object!
            }
        }
        return nil
    }
}

