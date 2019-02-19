//
//  TransactionsViewController.swift
//  mbanking
//
//  Created by Azra Mesic on 15/02/2019.
//  Copyright © 2019 Azra Mesic. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TransactionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var data = [Int: Account]()
    var accountId: Int? = nil
    var keys = [Date]()

    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var ibanLabel: UILabel!
    @IBOutlet weak var accountView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func options(_ sender: Any) {
        let alertController = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        if data.count > 1 {
            alertController.addAction(UIAlertAction(title: "Change account", style: .default, handler: { (action: UIAlertAction!) in
                self.changeAccount()
            }))
        }
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (action: UIAlertAction!) in
            self.logOut()
        }))
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.accountId = self.data.keys.first

        self.loadData()
        self.setViews()
    }
    
    func setViews() {
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        accountView.layer.cornerRadius = 10
        accountView.layer.shadowColor = UIColor.gray.cgColor
        accountView.layer.shadowOpacity = 0.3
        accountView.layer.shadowOffset = CGSize.zero
        accountView.layer.shadowRadius = 6
    }
    
    func loadData() {
        self.keys = Array(data[accountId!]!.transactions.keys).sorted{ $0 > $1 }
        
        balanceLabel.text = data[accountId!]!.amount
        currencyLabel.text = data[accountId!]!.currency
        ibanLabel.attributedText = self.createAttributedText("IBAN\n", subtitle: data[accountId!]!.iban)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data[accountId!]!.transactions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[accountId!]!.transactions[self.keys[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let transaction = data[accountId!]!.transactions[self.keys[indexPath.section]]![indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell", for: indexPath)
        
        if let date = cell.viewWithTag(1) as? UILabel {
            date.text = Utils.stringFromDate(transaction.date, toFormat: "d.")
        }
        if let descriptionLabel = cell.viewWithTag(2) as? UILabel {
            descriptionLabel.attributedText = self.createAttributedText(transaction.description, subtitle: transaction.type != nil ? "\n" + transaction.type! : "")
        }
        if let amountLabel = cell.viewWithTag(3) as? UILabel {
            if transaction.amount.first == "-" {
                amountLabel.textColor = UIColor.customRed()
            } else {
                amountLabel.textColor = UIColor.customGreen()
            }
            amountLabel.text = transaction.amount
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height / 5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        returnedView.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
        
        let label = UILabel(frame: CGRect(x: 20, y: 10, width: view.frame.size.width, height: 25))
        label.attributedText = NSMutableAttributedString(string: Utils.stringFromDate(self.keys[section], toFormat: "MMMM YYYY."), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20.0), NSAttributedString.Key.foregroundColor: UIColor(red:0.57, green:0.58, blue:0.65, alpha:1.0)])
        returnedView.addSubview(label)
        
        return returnedView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func createAttributedText(_ title: String, subtitle: String) -> NSMutableAttributedString {
        let attrString = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0)])
        attrString.append(NSMutableAttributedString(string: subtitle, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.0), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        return attrString
    }
    
    func changeAccount() {
        let selectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "selectionViewController") as! SelectionViewController
        selectionViewController.options = self.prepareAccounts()
        selectionViewController.sender = self
        selectionViewController.selected = self.accountId
        self.navigationController!.addChild(selectionViewController)
        selectionViewController.view.frame = self.navigationController!.view.frame
        self.navigationController?.view.addSubview(selectionViewController.view)
        selectionViewController.didMove(toParent: self)
    }
    
    func prepareAccounts() -> Array<Dictionary<Int, NSMutableAttributedString>> {
        var options = [[Int: NSMutableAttributedString]]()
        for account in self.data {
            let attrString = NSMutableAttributedString(string: account.value.currency + "\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20.0), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
            attrString.append(NSMutableAttributedString(string: account.value.iban, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0), NSAttributedString.Key.foregroundColor: UIColor.darkGray]))
            options.append([account.value.id: attrString])
        }
        return options
    }
    
    func reloadData(accountId: Int) {
        self.accountId = accountId
        self.loadData()
        self.tableView.reloadData()
    }
    
    func logOut() {
        LoginManager.updateRootVC()
    }
 
}
