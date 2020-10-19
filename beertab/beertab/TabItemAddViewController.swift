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
    
        saveButton.isEnabled = shouldDoneButtonBeEnabled()
    }
    
    @IBAction func savePressed(_ sender: Any) {
        if let tabUpdater = tabUpdater {
            createTabItems(tabUpdater)
            navigationController?.popViewController(animated:true)
        }
    }
    
    func createTabItems(_ tabUpdater: TabUpdater) {
        if pintPriceText?.inPence() == 0 && halfPriceText?.inPence() == 0 && thirdPriceText?.inPence() == 0 && twoThirdPriceText?.inPence() == 0 && otherPrice?.inPence() == 0 {
            tabUpdater.addTabItems(tabItems: [tabItemFromView(size:"Any", price:0)] )
        } else {
            createTabItemForEachPrice(tabUpdater:tabUpdater)
        }
    }
    
    func createTabItemForEachPrice(tabUpdater:TabUpdater) {
        let prices = [(size:"Pint", price:pintPriceText?.inPence() ?? 0 ),
                      (size:"Half", price:halfPriceText?.inPence() ?? 0),
                      (size:"1/3", price:thirdPriceText?.inPence() ?? 0),
                      (size:"2/3", price:twoThirdPriceText?.inPence() ?? 0),
                      (size:"Other", price:otherPrice?.inPence() ?? 0)]
        let tabItems = prices.map{tabItemFromView(size:$0.size, price:($0.price)) }.filter{$0.price != 0}
        tabUpdater.addTabItems(tabItems: tabItems)
    }

    func tabItemFromView(size:String, price:Int) -> TabItem {
        guard let brewer = brandTextField.text, let name = nameTextField.text else {return TabItem(brewer: "", name: "", size: "", price: 0)}
        return TabItem(brewer: brewer, name: name, size: size, price: price)
    }
    
    func deleteTabItem(tabItem:TabItem) {
        let deleteAlert = UIAlertController(title: "Are You Sure", message: "Do you want to delete \(tabItem.brewer) \(tabItem.name) (\(tabItem.size))", preferredStyle: UIAlertController.Style.alert)

        deleteAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.tabUpdater?.deleteTabItem(tabItem:tabItem)
            self.navigationController?.popViewController(animated:true)
        }))

        deleteAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler:nil))

        present(deleteAlert, animated: true, completion: nil)
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        saveButton.isEnabled = shouldDoneButtonBeEnabled()
    }
        
    func shouldDoneButtonBeEnabled() -> Bool {
        return (brandTextField.text != "" || nameTextField.text != "")
    }

}

extension UITextField {
    func inPence() -> Int {
        guard let text = self.text?.split(separator:" ").joined() else {return 0}
        do { return try createCurrency(string: text).inPence()
        } catch   {
            return 0
        }
    }
}