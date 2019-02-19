//
//  LoginController.swift
//  mbanking
//
//  Created by Azra Mesic on 15/02/2019.
//  Copyright © 2019 Azra Mesic. All rights reserved.
//

import UIKit

class LoginController: UIViewController, PinViewControllerDelegate {

    var spinnerView = UIView()
    var data = [Int: Account]()

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func logIn(_ sender: Any) {
        self.presentDialog()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = UserDefaults.standard.value(forKey: "name") as? String {
            self.titleLabel.text = name
        }
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
        let code = Keychain.get("pin")
        self.spinnerView = Spinner.sharedInstance.addSpinnerView(self.view, text: "Please wait...")
        if code != nil && Utils.MD5(Utils.MD5(pin + "f081b4baad80d81868bbb")!)! == String(code!) {
            self.view.isUserInteractionEnabled = false
            UserDefaults.standard.set(true, forKey: "hasLoginKey")
            RequestManager.getData { (data, error) in
                if error != nil {
                    self.spinnerView.removeFromSuperview()
                    AlertManager.sharedInstance.createAlert("Error", message: "Please try again later", controller: self)
                } else if let data = data {
                    self.data = data
                    self.displayTransactions()
                }
            }
        } else {
            self.spinnerView.removeFromSuperview()
            AlertManager.sharedInstance.createAlert("Error", message: "Invalid credentials", controller: self)
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
