//
//  Loader.swift
//  rentalsystems
//
//  Created by Azra Mesic on 18/02/2019.
//  Copyright © 2019 Azra Mesic. All rights reserved.
//

import Foundation
import UIKit

class Spinner: NSObject {
    
    static let sharedInstance = Spinner()
    
    func addSpinnerView(_ view: UIView, text: String, basedOnScreen: Bool? = false, mainWindow: Bool? = false) -> UIView {
        var boxView = UIView()
        boxView = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY, width: 180, height: 50))
        boxView.backgroundColor = UIColor.white
        boxView.alpha = 0.8
        boxView.layer.cornerRadius = 10
        
        let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        activityView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityView.startAnimating()
        
        let textLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        textLabel.textColor = UIColor.gray
        textLabel.text = text
        
        boxView.addSubview(activityView)
        boxView.addSubview(textLabel)
        
        view.addSubview(boxView)
        
        return boxView
    }
    
    func startSpinner(_ view: UIView, point: CGPoint? = nil, mainWindow: Bool? = false) -> UIActivityIndicatorView {
        let activityView = UIActivityIndicatorView(style: .white)
        activityView.color = UIColor.gray
        if (point != nil) {
            activityView.center = point!
        } else {
            activityView.center = view.center
        }
        activityView.startAnimating()
        if mainWindow == true {
            UIApplication.shared.keyWindow?.addSubview(activityView)
        } else {
            view.addSubview(activityView)
        }
        return activityView
    }
}
