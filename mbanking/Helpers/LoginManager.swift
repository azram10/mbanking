//
//  LoginManager.swift
//  mbanking
//
//  Created by Azra Mesic on 15/02/2019.
//  Copyright © 2019 Azra Mesic. All rights reserved.
//

import UIKit

class LoginManager: NSObject {
    
    static func updateRootVC() {
        var rootVC : UIViewController?
        let token = Keychain.get("pin")
        
        if let loginKey = UserDefaults.standard.value(forKey: "hasLoginKey") as? Bool {
            if loginKey && token != nil {
                rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginController") as! LoginController
            }
        }
        if (rootVC as? LoginController) == nil {
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "registerController") as! RegisterViewController
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootVC
    }
    
}
