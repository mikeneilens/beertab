//
//  ReceiptViewController.swift
//  beertab
//
//  Created by Michael Neilens on 11/10/2020.
//

import UIKit

class ReceiptViewController: UIViewController {
    var tab = Tab(name: "", createTS: Date(), pubName: "", branch: "", id: "", tabItems: [])
    
    @IBOutlet weak var receiptTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        receiptTextView.text = tab.transactionsReport()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
