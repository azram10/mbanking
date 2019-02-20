//
//  TableViewCell.swift
//  mbanking
//
//  Created by Azra Mesic on 19/02/2019.
//  Copyright © 2019 Azra Mesic. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var contentContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if highlighted {
            contentContainerView.layer.shadowColor = UIColor.gray.cgColor
            contentContainerView.layer.shadowOpacity = 0.3
            contentContainerView.layer.shadowOffset = CGSize.zero
            contentContainerView.layer.shadowRadius = 6
        } else {
            contentContainerView.layer.shadowOpacity = 0.0
            contentContainerView.layer.shadowColor = UIColor.clear.cgColor
            contentContainerView.layer.shadowOffset = CGSize(width: 0 , height: 0)
            contentContainerView.layer.shadowRadius = 0
        }
    }
    
    func setValues(transaction: Transaction) {
        dateLabel.text = Utils.stringFromDate(transaction.date, toFormat: "d.")
        descriptionLabel.attributedText = Utils.createAttributedText(transaction.description, subtitle: transaction.type != nil ? "\n" + transaction.type! : "")
        
        if transaction.amount.first == "-" {
            amountLabel.textColor = UIColor.customRed()
        } else {
            amountLabel.textColor = UIColor.customGreen()
        }
        amountLabel.text = transaction.amount
    }
}
