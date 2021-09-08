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
    override func viewDidLoad() {
        super.viewDidLoad()
        receiptTextView.text = tab.transactionsReport()
    }

}
