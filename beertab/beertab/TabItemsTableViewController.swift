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
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tabItemCell", for: indexPath)
            configureTabItemCell(cell, indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tabTotalCell", for: indexPath)
            configureSummaryCell(cell)
            return cell
        }
    }
    
    func configureTabItemCell(_ cell: UITableViewCell, _ indexPath: IndexPath) {
        if let tabItemCell = cell as? TabItemTableViewCell {
            tabItemCell.brewer.text = tab.tabItems[indexPath.row].brewer
            tabItemCell.name.text = tab.tabItems[indexPath.row].name
            tabItemCell.size.text = "\(tab.tabItems[indexPath.row].size) £\(tab.tabItems[indexPath.row].priceGBP)"
            tabItemCell.quantity.text = String(tab.tabItems[indexPath.row].quantity)
            tabItemCell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        }
    }
    
    func configureSummaryCell(_ cell: UITableViewCell) {
          if let tabTotalCell = cell as? TabTotalTableViewCell {
              tabTotalCell.totalValue.text = "£\(tab.totalValue)"
              tabTotalCell.isUserInteractionEnabled = false
          }
    }
      
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            if tab.tabItems.count > 0 {
                return "Items"
            } else {
                return "You have no items on your tab"
            }
        }
        else {return "Your Total Bill"}
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteTabItem(indexPath: indexPath)
        }
    }
    
    func deleteTabItem(indexPath:IndexPath) {
        let tabItem = tab.tabItems[indexPath.row]
        
        let deleteAlert = UIAlertController(title: "Are You Sure", message: "Do you want to delete \(tabItem.brewer) \(tabItem.name) (\(tabItem.size))", preferredStyle: UIAlertController.Style.alert)

        deleteAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.deleteTabItem(tabItem: tabItem)
            self.tableView.deleteRows(at:[indexPath], with: .fade)
        }))

        deleteAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler:nil))

        present(deleteAlert, animated: true, completion: nil)
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectedRow = tableView.indexPathForSelectedRow?.row
        prepareDestination(segue.destination, row:selectedRow)
    }
    
    func prepareDestination(_ destination: UIViewController, row:Int?) {
        switch destination {
        case let tabItemAddViewController as TabItemAddViewController : prepare(tabItemAddViewController)
        case let tabItemUpdateViewController as TabItemUpdateViewController : prepare(tabItemUpdateViewController, row:row)
        default: break
        }
    }

    func prepare(_ tabItemAddViewController:TabItemAddViewController) {
        tabItemAddViewController.tabUpdater = self
    }
    
    func prepare(_ tabItemUpdateViewController:TabItemUpdateViewController, row:Int?) {
        tabItemUpdateViewController.tabItem = selectTabItem(row:row)
        tabItemUpdateViewController.tabUpdater = self
    }
    
    func selectTabItem(row:Int?) -> TabItem {
        if let selectedRow = row {
            return tab.tabItems[selectedRow]
        }
        else {
            return TabItem(brewer: "", name: "", size: "", price: 0)
        }
    }
    
    func addTabItem(tabItem: TabItem) {
        tab = tab.add(tabItem: tabItem)
        history = history.update(tab: tab)
        history.save(key:archiveKey, errorResponse: errorWritingHistory(history:message:))
    }
    
    func buyTabItem(tabItem: TabItem) {
        tab = tab.addTransaction(brewer: tabItem.brewer, name: tabItem.name, size: tabItem.size)
        history = history.update(tab: tab)
        history.save(key:archiveKey, errorResponse: errorWritingHistory(history:message:))
    }
    
    func returnTabItem(tabItem: TabItem) {
        tab = tab.removeTransaction(brewer: tabItem.brewer, name: tabItem.name, size: tabItem.size)
        history = history.update(tab: tab)
        history.save(key:archiveKey, errorResponse: errorWritingHistory(history:message:))
    }
    func deleteTabItem(tabItem: TabItem) {
        tab = tab.remove(tabItem: tabItem)
        history = history.update(tab: tab)
        history.save(key:archiveKey, errorResponse: errorWritingHistory(history:message:))
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
