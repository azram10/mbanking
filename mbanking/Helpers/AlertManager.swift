//
//  AlertManager.swift
//  rentalsystems
//
//  Created by Azra Mesic on 15/02/2019.
//  Copyright © 2019 Azra Mesic. All rights reserved.
//

import UIKit

class AlertManager: NSObject {
    
    static let sharedInstance = AlertManager()
    
    func createAlert(_ title: String, message: String, controller: AnyObject) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(okAction)
        controller.present(alertController, animated: true, completion: nil)
    }

}
