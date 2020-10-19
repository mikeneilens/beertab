//
//  TabItemUpdateViewController.swift
//  beertab
//
//  Created by Michael Neilens on 07/10/2020.
//

import UIKit

class TabItemUpdateViewController: UIViewController, UITextFieldDelegate {

    var tabUpdater:TabUpdater? = nil
    var tabItem = TabItem(brewer: "", name: "", size: "", price: 0)
    var position = 0
    
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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        brandTextField.delegate = self
        nameTextField.delegate = self

        brandTextField.text = tabItem.brewer
        nameTextField.text = tabItem.name
        sizeTextField.text = tabItem.size
        priceTextField.text = tabItem.priceGBP
        qtyTextField.text = String(tabItem.quantity)
        
        deleteButton.isEnabled = shouldDeleteButtonBeEnabled()
    }
    
    func shouldDeleteButtonBeEnabled() -> Bool {
        return (tabItem.quantity > 0)
    }
    
    @IBAction func buyPressed(_ sender: Any) {
        guard let tabUpdater = tabUpdater else {return}
        buyTabItem(tabUpdater:tabUpdater, {self.navigationController?.popViewController(animated:true)})
    }
    
    func buyTabItem(tabUpdater:TabUpdater, _ completion:()->()) {
        tabUpdater.buyTabItem(tabItem: tabItem)
        completion()
    }
        
    @IBAction func deletePressed(_ sender: Any) {
        guard let tabUpdater = tabUpdater else {return}
        returnTabItem(tabUpdater: tabUpdater, {self.navigationController?.popViewController(animated:true)})
    }
    
    func returnTabItem(tabUpdater:TabUpdater, _ completion:()->()) {
        tabUpdater.returnTabItem(tabItem: tabItem)
        completion()
    }
    
    @IBAction func editBrandButtonPressed(_ sender: Any) {
        setTextFieldToEdit(textField: brandTextField)
    }
    @IBAction func editNameButtonPressed(_ sender: Any) {
        setTextFieldToEdit(textField: nameTextField)
    }
    @IBAction func editPriceButtonPressed(_ sender: Any) {
        setTextFieldToEdit(textField: priceTextField)
    }
    
    func setTextFieldToEdit(textField:UITextField ) {
        textField.delegate = self
        textField.isEnabled = true
        textField.isUserInteractionEnabled = true
        textField.becomeFirstResponder()
    }
    func setAllTextFieldsNotToEdit() {
        [brandTextField, nameTextField, priceTextField].forEach{textfield in setTextFieldToNotEdit(textField: textfield)}
    }
    func setTextFieldToNotEdit(textField:UITextField ) {
        textField.delegate = nil
        textField.isEnabled = false
        textField.isUserInteractionEnabled = false
        textField.resignFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        setAllTextFieldsNotToEdit()
        if textHasChanged() {
            replaceTabItem()
        }
        return true
    }
    
    func textHasChanged() -> Bool {
        return tabItem.brewer != brandTextField.text || tabItem.name != nameTextField.text || tabItem.size != sizeTextField.text || tabItem.price.priceGBP != priceTextField.text
    }
    
    func replaceTabItem() {
        tabItem = tabItemFromView()
        self.tabUpdater?.replaceTabItem(position: position, newTabItem: tabItem)
    }
    
    func tabItemFromView() -> TabItem {
        guard let brewer = brandTextField?.text, let name = nameTextField?.text, let size = sizeTextField?.text, let price = priceTextField?.inPence() else {return TabItem(brewer: "", name: "", size: "", price: 0)}
        return TabItem(brewer: brewer, name: name, size: size, price: price, transactions: tabItem.transactions)
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
