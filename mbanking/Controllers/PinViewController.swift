//
//  PinViewController.swift
//  mbanking
//
//  Created by Azra Mesic on 13/02/2019.
//  Copyright © 2019 Azra Mesic. All rights reserved.
//

import UIKit

protocol PinViewControllerDelegate: class {
    func login(pin: String)
}

class PinViewController: UIViewController, KeyboardDelegate {

    @IBOutlet weak var pinTextField: UITextField!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var viewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewTopConstraint: NSLayoutConstraint!
    
    var delegate: PinViewControllerDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        let keyboardView = Keyboard(frame: CGRect(x: 0, y: 0, width: 0, height: self.view.frame.size.height * 3/5))
        keyboardView.delegate = self
        self.viewBottomConstraint.constant = keyboardView.frame.size.height - viewBottomConstraint.constant
        self.pinTextField.setLeftPaddingPoints(10)
        self.pinTextField.inputView = keyboardView
        self.pinTextField.becomeFirstResponder()
    }

    // required methods for keyboard delegate protocol
    func keyWasTapped(character: String) {
        self.pinTextField.insertText(character)
    }
    
    func keyboardConfirm() {
        if self.validatePin() {
            self.delegate?.login(pin: pinTextField.text!)
            self.view.removeFromSuperview()
        }
    }
    
    func keyboardDelete() {
        pinTextField.text = String(pinTextField.text!.dropLast())
    }
    
    func keyboardClose() {
        self.view.removeFromSuperview()
    }
    // end required methods for keyboard delegate protocol
    
    func validatePin() -> Bool {
        if self.pinTextField.text == "" || self.pinTextField.text!.count < 4 || self.pinTextField.text!.count > 6  {
            AlertManager.sharedInstance.createAlert("Warning", message: "Pin must be within 4 and 6 numbers", controller: self)
            return false
        }
        return true
    }

}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension UIView {
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
