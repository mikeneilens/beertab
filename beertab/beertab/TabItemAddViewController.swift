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
    
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        brandTextField.delegate = self
        nameTextField.delegate = self
    
        setDoneButtonState()
    }
    
    @IBAction func donePressed(_ sender: Any) {
        if let tabUpdater = tabUpdater {
            if pintPriceText.inPence() == 0 && halfPriceText.inPence() == 0 && thirdPriceText.inPence() == 0 && twoThirdPriceText.inPence() == 0 && otherPrice.inPence() == 0 {
                tabUpdater.addTabItem(tabItem: tabItemFromView(size:"Any", price:0) )
            } else {
                createTabItemForEachPrice()
            }
            navigationController?.popViewController(animated:true)
        }
    }

    func tabItemFromView(size:String, price:Int) -> TabItem {
        guard let brewer = brandTextField.text, let name = nameTextField.text else {return TabItem(brewer: "", name: "", size: "", price: 0)}
        
        return TabItem(brewer: brewer, name: name, size: size, price: price)
    }
    func createTabItemForEachPrice() {
        guard let tabUpdater = tabUpdater else {return}
        let prices = [(size:"Pint", price:pintPriceText.inPence()),
                      (size:"Half", price:halfPriceText.inPence()),
                      (size:"1/3", price:thirdPriceText.inPence()),
                      (size:"2/3", price:twoThirdPriceText.inPence()),
                      (size:"Other", price:otherPrice.inPence())]
        prices.forEach{
            if $0.price != 0 {
                tabUpdater.addTabItem(tabItem: tabItemFromView(size:$0.size, price:$0.price))
            }
        }
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
        setDoneButtonState()
    }
        
    func setDoneButtonState() {
        if (brandTextField.text == "" && nameTextField.text == "")  {
            doneButton.isEnabled = false
        } else {
            doneButton.isEnabled = true
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

extension UITextField {
    func inPence() -> Int {
        guard let text = self.text else {return 0}
        return Int((Double(text) ?? 0) * 100) 
    }
}
