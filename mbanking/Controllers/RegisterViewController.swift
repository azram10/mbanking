//
//  ViewController.swift
//  mbanking
//
//  Created by Azra Mesic on 13/02/2019.
//  Copyright © 2019 Azra Mesic. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, PinViewControllerDelegate {
    
    let maxCharaters = 30
    var spinnerView = UIView()
    var data = [Int: Account]()
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    
    @IBAction func register(_ sender: Any) {
        if let message = self.getRegisterValidationMessage() {
            AlertManager.sharedInstance.createAlert("Warning", message: message, controller: self)
        } else {
            self.presentDialog()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getRegisterValidationMessage() -> String? {
        if firstName.text == "" || lastName.text == "" {
            return "First and last name are required"
        } else if !firstName.text!.isAlphanumeric() || !lastName.text!.isAlphanumeric() {
            return "First and last name must have only alfanumeric"
        } else if firstName.text!.count > self.maxCharaters || lastName.text!.count > self.maxCharaters {
            return "First and last name must have less than" + String(self.maxCharaters) + "characters"
        }
        return nil
    }

    func presentDialog() {
        let dialogViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "dialogViewController") as! PinViewController
        dialogViewController.delegate = self
        self.addChild(dialogViewController)
        dialogViewController.view.frame = self.view.frame
        self.view.addSubview(dialogViewController.view)
        dialogViewController.didMove(toParent: self)
    }
    
    func login(pin: String) {
        let tokedSaved = Keychain.set("pin", value: Utils.MD5(Utils.MD5(pin + "f081b4baad80d81868bbb")!)!)

        if tokedSaved {
            self.view.isUserInteractionEnabled = false
            self.spinnerView = Spinner.sharedInstance.addSpinnerView(self.view, text: "Please wait...")
            UserDefaults.standard.set(String(describing: self.firstName.text! + " " + self.lastName.text!), forKey: "name")
            UserDefaults.standard.set(true, forKey: "hasLoginKey")
            RequestManager.getData { (data, error) in
                if error != nil {
                    self.view.isUserInteractionEnabled = true
                    self.spinnerView.removeFromSuperview()
                    AlertManager.sharedInstance.createAlert("Error", message: "Please try again later", controller: self)
                } else if let data = data {
                    self.data = data
                    self.displayTransactions()
                }
            }
        }
    }
    
    func displayTransactions() {
        self.performSegue(withIdentifier: "transactions", sender: self)
        self.spinnerView.removeFromSuperview()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "transactions" {
            let controller = segue.destination as? UINavigationController
            if let visibleController = controller!.viewControllers.first as? TransactionsViewController {
                visibleController.data = self.data
            }
        }
    }
}

extension String {
    
    func isAlphanumeric() -> Bool {
        return self.range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    func isNumeric() -> Bool {
        return self.range(of: "[^0-9]", options: .regularExpression) == nil
    }
    
}
