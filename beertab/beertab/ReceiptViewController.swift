//
//  ReceiptViewController.swift
//  beertab
//
//  Created by Michael Neilens on 11/10/2020.
//

import UIKit

class ReceiptViewController: UIViewController {
    var tab = Tab(name: "", createTS: Date(), pubName: "", branch: "", id: "")
    
    @IBOutlet weak var receiptTextView: UITextView!
    @IBOutlet weak var billIdText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        receiptTextView.text = tab.transactionsReport()
        billIdText.text = getBill().billId
    }
    
    func getBill() -> Bill {
        if let bill = bills.billContaining(tab: tab) {
            return bill
        } else {
            let newBill = Bill(tab: tab)
            bills += [newBill]
            return newBill
        }
    }
}
