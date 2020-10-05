//
//  TabItemViewController.swift
//  beertab
//
//  Created by Michael Neilens on 05/10/2020.
//

import UIKit

class TabItemViewController: AbstractViewController, UITextFieldDelegate {

    enum DisplayState {
        case update
        case readOnly(_ tabItem:TabItem)
    }
    var displayState:DisplayState = .update
    
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var sizeTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var qtyTextField: UITextField!
    
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        brandTextField.delegate = self
        nameTextField.delegate = self
    
        switch displayState {
        case .update: displayForEdit()
        case .readOnly: displayForReadOnly()
        }
        setDoneButtonState()
    }
    
    @IBAction func donePressed(_ sender: Any) {
    }
    
    @IBAction func buyPressed(_ sender: Any) {
    }
    
    @IBAction func deletePressed(_ sender: Any) {
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        setDoneButtonState()
    }
    
    func displayForReadOnly() {
        if case .readOnly(let tabItem) = displayState {
            brandTextField.text = tabItem.brewer
            nameTextField.text = tabItem.name
            sizeTextField.text = tabItem.size
            priceTextField.text = String(tabItem.price)
            qtyTextField.text = String(tabItem.quantity)
        }
        setDisplay(state: false)
    }
    func displayForEdit() {
        setDisplay(state: true)
    }
    func setDisplay(state:Bool) {
        brandTextField.isEnabled = state
        nameTextField.isEnabled = state
        sizeTextField.isEnabled = state
        priceTextField.isEnabled = state
        qtyLabel.isHidden = state
        qtyTextField.isHidden = state
        qtyTextField.isEnabled = false
        buyButton.isHidden = state
        deleteButton.isHidden = state
    }
    
    func setDoneButtonState() {
        if (brandTextField.text == "" && nameTextField.text == "")  {
            doneButton.isEnabled = false
        } else {
            if case .update = displayState {
                doneButton.isEnabled = true
            } else {
                doneButton.isEnabled = false
            }
        }
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
