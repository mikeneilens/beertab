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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
