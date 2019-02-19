//
//  CustomButton.swift
//  rentalsystems
//
//  Created by Azra Mesic on 15/02/2019.
//  Copyright © 2019 Azra Mesic. All rights reserved.
//

import Foundation
import UIKit

class CustomButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 4.0
        clipsToBounds = true
    }

    override func draw(_ rect: CGRect) {
        var frameRect: CGRect = self.frame;
        frameRect.size.height = 50;
        self.frame = frameRect;
    }
}
