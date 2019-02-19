//
//  KeyboardButton.swift
//  mbanking
//
//  Created by Azra Mesic on 15/02/2019.
//  Copyright © 2019 Azra Mesic. All rights reserved.
//

import UIKit

class KeyboardButton: UIButton {

    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.keyboardHighlighted() : UIColor.keyboardBackground()
        }
    }
}
