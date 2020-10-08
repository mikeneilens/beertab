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

        if tabItem.quantity == 0 {
            deleteButton.setTitle("Delete Item", for: .normal)
            deleteButton.setTitleColor(UIColor.red, for: .normal)
        }
    }

    func tabItemFromView() -> TabItem {
        guard let brewer = brandTextField.text, let name = nameTextField.text, let size = sizeTextField.text, let price = priceTextField.text else {return TabItem(brewer: "", name: "", size: "", price: 0)}
        
        return TabItem(brewer: brewer, name: name, size: size, price: Int(100.0 * (Double(price) ?? 0)))
    }
    
    @IBAction func buyPressed(_ sender: Any) {
        if  let tabUpdater = tabUpdater  {
            tabUpdater.buyTabItem(tabItem: tabItem)
            navigationController?.popViewController(animated:true)
        }
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        if  let tabUpdater = tabUpdater  {
            if tabItem.quantity > 0 {
                tabUpdater.returnTabItem(tabItem:tabItem)
                navigationController?.popViewController(animated:true)
            } else {
                deleteTabItem(tabItem:tabItem)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
