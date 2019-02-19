//
//  SelectionViewController.swift
//  mbanking
//
//  Created by Azra Mesic on 15/02/2019.
//  Copyright © 2019 Azra Mesic. All rights reserved.
//

import UIKit

protocol SelectionViewControllerDelegate: class {
    func login()
}

class SelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBAction func close(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
    @IBAction func apply(_ sender: Any) {
        if let controller = self.sender as? TransactionsViewController {
            controller.reloadData(accountId: self.selected!)
            self.view.removeFromSuperview()
        }
    }
    
    var delegate: SelectionViewControllerDelegate? = nil
    var options = [[Int: NSMutableAttributedString]]()
    var selected: Int? = nil
    var sender: AnyObject? = nil
    var checkedIndexPath: IndexPath? = nil
    var titleText: String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.closeButton.layer.cornerRadius = 15
        self.closeButton.layer.borderWidth = 1
        self.closeButton.layer.borderColor = UIColor.appColor().cgColor
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectionCell", for: indexPath)
        if let label = cell.viewWithTag(1) as? UILabel {
            label.attributedText = getTextForRow(indexPath)!
            label.sizeToFit()
        }
        
        if selected != nil && selected != 0 && selected! == getKeyForRow(indexPath) {
            cell.accessoryType = .checkmark
            checkedIndexPath = indexPath
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath != checkedIndexPath {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            if checkedIndexPath != nil {
                tableView.cellForRow(at: checkedIndexPath!)?.accessoryType = .none
            }
            checkedIndexPath = indexPath
            selected = getKeyForRow(indexPath)
        }
    }
    
    func getTextForRow(_ indexPath: IndexPath) -> NSMutableAttributedString? {
        for (_,value) in options[indexPath.row] {
            return value
        }
        return nil
    }
    
    func getKeyForRow(_ indexPath: IndexPath) -> Int {
        for (key,_) in options[indexPath.row] {
            return key
        }
        
        return 0
    }

}
