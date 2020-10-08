//
//  TabItemsTableViewController.swift
//  beertab
//
//  Created by Michael Neilens on 04/10/2020.
//

import UIKit

protocol TabUpdater {
    func addTabItem(tabItem:TabItem)
    func buyTabItem(tabItem:TabItem)
    func returnTabItem(tabItem:TabItem)
    func deleteTabItem(tabItem:TabItem)
}

class TabItemsTableViewController: AbstractTableViewController, TabUpdater {
    
    var tab = Tab(name: "", createTS: Date(), pubName: "", branch: "", id: "", tabItems: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !tab.pubName.isEmpty {
            self.navigationItem.title = tab.pubName
        } else {
            self.navigationItem.title = tab.name
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if tab.tabItems.isEmpty {
            return 1
        } else {
            return 2
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if tab.tabItems.isEmpty {
            return 0
        } else {
            if section == 0 { return tab.tabItems.count } else {return 1}
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tabItemCell", for: indexPath)
        if let tabItemCell = cell as? TabItemTableViewCell {
            if indexPath.section == 0 {
                tabItemCell.brewer.text = tab.tabItems[indexPath.row].brewer
                tabItemCell.name.text = tab.tabItems[indexPath.row].name
                tabItemCell.size.text = "\(tab.tabItems[indexPath.row].size) £\(tab.tabItems[indexPath.row].priceGBP)"
                tabItemCell.quantity.text = String(tab.tabItems[indexPath.row].quantity)
                tabItemCell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            } else {
                tabItemCell.brewer.isHidden = true
                tabItemCell.name.isHidden = true
                tabItemCell.quantity.isHidden = true
                tabItemCell.size.text = "£ \(tab.totalValue)"
                tabItemCell.isUserInteractionEnabled = false
            }
        }
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {return "Items"}
        else {return "Your Total Bill"}
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController =  segue.destination
        
        switch (segue.identifier) {
        case "addTabItem": prepareToAdd(viewController)
        default: prepareToUpdate(viewController)
        }
    }
    func prepareToAdd(_ viewController:UIViewController) {
        guard let tabItemViewController =  viewController as? TabItemAddViewController else {return}
        tabItemViewController.tabUpdater = self
    }
    
    func prepareToUpdate(_ viewController:UIViewController) {
        guard let tabItemViewController =  viewController as? TabItemUpdateViewController else {return}
        tabItemViewController.tabItem = selectTabItem()
        tabItemViewController.tabUpdater = self
    }
    
    func selectTabItem() -> TabItem {
        if let selectedRow = tableView.indexPathForSelectedRow?.row {
            return tab.tabItems[selectedRow]
        }
        else {
            return TabItem(brewer: "", name: "", size: "", price: 0)}
    }
    
    func addTabItem(tabItem: TabItem) {
        tab = tab.add(tabItem: tabItem)
        history = history.update(tab: tab)
        history.save(errorResponse: errorWritingHistory(history:message:))
    }
    
    func buyTabItem(tabItem: TabItem) {
        tab = tab.addTransaction(brewer: tabItem.brewer, name: tabItem.name, size: tabItem.size)
        history = history.update(tab: tab)
        history.save(errorResponse: errorWritingHistory(history:message:))
    }
    
    func returnTabItem(tabItem: TabItem) {
        tab = tab.removeTransaction(brewer: tabItem.brewer, name: tabItem.name, size: tabItem.size)
        history = history.update(tab: tab)
        history.save(errorResponse: errorWritingHistory(history:message:))
    }
    func deleteTabItem(tabItem: TabItem) {
        tab = tab.remove(tabItem: tabItem)
        history = history.update(tab: tab)
        history.save(errorResponse: errorWritingHistory(history:message:))
    }
    
    func errorWritingHistory(history:History, message:String) {
        print("error writing history: \(message)")
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
