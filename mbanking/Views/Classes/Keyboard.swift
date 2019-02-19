//
//  Keyboard.swift
//  mbanking
//
//  Created by Azra Mesic on 13/02/2019.
//  Copyright © 2019 Azra Mesic. All rights reserved.
//

import UIKit

protocol KeyboardDelegate: class {
    func keyWasTapped(character: String)
    func keyboardConfirm()
    func keyboardDelete()
    func keyboardClose()
}

class Keyboard: UIView {
    
    weak var delegate: KeyboardDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }
    
    func initializeSubviews() {
        let xibFileName = "Keyboard"
        Bundle.main.loadNibNamed(xibFileName, owner: nil, options: nil)
        let view = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)?[0] as! UIView
        if let backButton = view.viewWithTag(11) as? UIButton {
            let image = UIImage(named: "delete.png")?.withRenderingMode(.alwaysTemplate)
            backButton.setImage(image, for: .normal)
            backButton.tintColor = UIColor.keyboardText()
        }
        self.addSubview(view)
        view.frame = self.bounds
    }
    
    @IBAction func deleteCharater(_ sender: Any) {
        self.delegate?.keyboardDelete()
    }
    
    @IBAction func confirm(_ sender: Any) {
        self.delegate?.keyboardConfirm()
    }
    
    @IBAction func close(_ sender: Any) {
        self.delegate?.keyboardClose()
    }
    
    @IBAction func keyTapped(_ sender: UIButton) {
        self.delegate?.keyWasTapped(character: sender.titleLabel!.text!)
    }
}
