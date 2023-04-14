//
//  TabItemViewController.swift
//  beertab
//
//  Created by Michael Neilens on 05/10/2020.
//

import UIKit

class TabItemAddViewController: AbstractViewController, UITextFieldDelegate {

    enum DisplayState {
        case update
        case readOnly(_ tabItem:TabItem)
    }
    
    var tabUpdater:TabUpdater? = nil
    
    
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var pintPriceText: UITextField!
    @IBOutlet weak var halfPriceText: UITextField!
    @IBOutlet weak var thirdPriceText: UITextField!
    @IBOutlet weak var twoThirdPriceText: UITextField!
    @IBOutlet weak var otherPrice: UITextField!
    
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        brandTextField.delegate = self
        nameTextField.delegate = self
        pintPriceText.delegate = self
        halfPriceText.delegate = self
        saveButton.isEnabled = doneButtonShouldBeEnabled()
    }
    
    @IBAction func savePressed(_ sender: Any) {
        if let tabUpdater {
            createTabItems(tabUpdater)
            navigationController?.popViewController(animated:true)
        }
    }
    
    func createTabItems(_ tabUpdater: TabUpdater) {
        if pintPriceText.inPence() == 0 && halfPriceText.inPence() == 0 && thirdPriceText.inPence() == 0 && twoThirdPriceText.inPence() == 0 && otherPrice.inPence() == 0 {
            tabUpdater.addTabItems(tabItems: [tabItemFromView(size:"Any", price:0)] )
        } else {
            tabUpdater.addTabItems(tabItems: tabItemsWithAPrice())
        }
    }
        
    func tabItemsWithAPrice() -> Array<TabItem> {
            [(size:"Pint", price:pintPriceText.inPence() ),
             (size:"Half", price:halfPriceText.inPence() ),
             (size:"1/3", price:thirdPriceText.inPence() ),
             (size:"2/3", price:twoThirdPriceText.inPence() ),
             (size:"Other", price:otherPrice.inPence() )]
            .compactMap(transformFieldToTabItem)
    }
    func transformFieldToTabItem(field:(size:String,price:Int) ) ->TabItem? {
        field.price != 0 ? tabItemFromView(size:field.size, price:(field.price)) : nil
    }
    
    func tabItemFromView(size:String, price:Int) -> TabItem {
        guard let brewer = brandTextField.text, let name = nameTextField.text else {return TabItem(brewer: "", name: "", size: "", price: 0)}
        return TabItem(brewer: brewer, name: name, size: size, price: price)
    }
    
    func deleteTabItem(tabItem:TabItem) {
        let deleteAlert = createDeleteAlert(tabItem: tabItem)
        present(deleteAlert, animated: true, completion: nil)
    }
    func createDeleteAlert(tabItem:TabItem) -> UIAlertController {
        UIAlertController(title: "Are You Sure", message: "Do you want to delete \(tabItem.brewer) \(tabItem.name) (\(tabItem.size))", preferredStyle: UIAlertController.Style.alert)
        .apply{ this in
            this.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                self.tabUpdater?.deleteTabItem(tabItem:tabItem)
                self.navigationController?.popViewController(animated:true)
            }))
            this.addAction(UIAlertAction(title: "No", style: .cancel, handler:nil))
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        saveButton.isEnabled = doneButtonShouldBeEnabled()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == pintPriceText { updateHalfField() }
        if textField == halfPriceText { updatePintField() }
    }
    
    func updateHalfField() {
        if pintPriceText.inPence() != 0 && halfPriceText.inPence() == 0 {
            let halfPintPrice = pintPriceText.inPence() / 2 + 10
            halfPriceText.text = halfPintPrice.priceGBP
        }
    }

    func updatePintField() {
        if halfPriceText.inPence() != 0 && pintPriceText.inPence() == 0 {
            let pintPintPrice = halfPriceText.inPence() * 2 - 20
            pintPriceText.text = pintPintPrice.priceGBP
        }
    }

    func doneButtonShouldBeEnabled() -> Bool {
        (brandTextField.text != "" || nameTextField.text != "")
    }

}
