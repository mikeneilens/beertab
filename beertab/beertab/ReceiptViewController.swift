//
//  ReceiptViewController.swift
//  beertab
//
//  Created by Michael Neilens on 11/10/2020.
//

import UIKit

class ReceiptViewController: AbstractViewController, UITextFieldDelegate  {
    var tab = Tab(name: "", createTS: Date(), pubName: "", branch: "", id: "")
    var billRepository:BillArchiver = BillRepository()
    
    @IBOutlet weak var receiptTextView: UITextView!
    @IBOutlet weak var billIdText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        billRepository.createOrUpdateBill(tab: tab, onCompletion: processBill(bill:), errorResponse: errorGettingBill(errorMessage:))
    }
    
    func processBill(bill:Bill) {
        billIdText.text = bill.billId
        receiptTextView.text =  bill.report(history: history)
    }
    
    func errorGettingBill(errorMessage:String?) {
        showErrorMessage(withMessage: errorMessage ?? "", withTitle: "There was a problem creating the bill")
    }
    
    @IBAction func editBillIdButtonPressd(_ sender: Any) {
        setTextFieldToEdit(textField: billIdText)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard textField.containsValidBillId() else {
            let alert = showInvalidBillIdAlert()
            self.navigationController?.present(alert, animated: true, completion: nil)
            return false
        }
        billRepository.updateBill(tab: tab, billId: textField.text ?? "", onCompletion: processBill(bill:), errorResponse: errorGettingBill(errorMessage:))
        setTextFieldToNotEdit(textField:textField)
        return true
    }
    
    func validate(textField:UITextField) {
        
    }
    
    func setTextFieldToEdit(textField:UITextField ) {
        textField.delegate = self
        textField.isEnabled = true
        textField.isUserInteractionEnabled = true
        textField.becomeFirstResponder()
    }
    
    func setTextFieldToNotEdit(textField:UITextField ) {
        textField.delegate = nil
        textField.isEnabled = false
        textField.isUserInteractionEnabled = false
        textField.resignFirstResponder()
    }
    
    func showInvalidBillIdAlert() -> UIAlertController {
        UIAlertController(title: "", message: "The Bill Id must be at least 4 characters.", preferredStyle: .alert
        ).apply{this in
            this.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
        }
    }
}

extension UITextField {
    func containsValidBillId() -> Bool {
        if let text {
            return text.count >= 4
        } else {
            return false
        }
    }
}
