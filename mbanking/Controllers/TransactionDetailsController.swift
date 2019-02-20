//
//  TransactionDetailsController.swift
//  mbanking
//
//  Created by Azra Mesic on 19/02/2019.
//  Copyright © 2019 Azra Mesic. All rights reserved.
//

import UIKit

class TransactionDetailsController: UIViewController {
    
    var transaction: Transaction? = nil

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var detailsLabel: UILabel!
    
    @IBAction func close(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.setCloseButton()
        self.loadData()
    }
    
    func setCloseButton() {
        self.closeButton.layer.cornerRadius = 15
        self.closeButton.layer.borderWidth = 1
        self.closeButton.layer.borderColor = UIColor.appColor().cgColor
    }
    
    func loadData() {
        let attrString = self.createAttributedText("Date: ", subtitle: Utils.stringFromDate(transaction?.date, toFormat: "d. MMMM YYYY.") + "\n" )
        attrString.append(self.createAttributedText("\nAmount: ", subtitle: (transaction?.amount ?? "" ) + "\n" ))
        if transaction?.type != "" {
            attrString.append(self.createAttributedText("\nType: ", subtitle: (transaction?.type ?? "") + "\n" ))
        }
        attrString.append(self.createAttributedText("\nDescription: ", subtitle: transaction?.description ?? ""))
        detailsLabel.attributedText = attrString
        detailsLabel.sizeToFit()
    }
    
    func createAttributedText(_ title: String, subtitle: String) -> NSMutableAttributedString {
        let attrString = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17.0)])
        attrString.append(NSMutableAttributedString(string: subtitle, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        return attrString
    }
}
