//
//  TabItemsTableViewController.swift
//  beertab
//
//  Created by Michael Neilens on 04/10/2020.
//

import UIKit

protocol TabUpdater {
    func addTabItem(tabItem:TabItem)
}

class TabItemsTableViewController: AbstractTableViewController, TabUpdater {

    var tab = Tab(name: "", createTS: Date(), pubName: "", postcode: "", tabItems: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = tab.text
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tab.tabItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tabItemCell", for: indexPath)
        cell.textLabel?.text = tab.tabItems[indexPath.row].text
        // Configure the cell...

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let tabItemViewController =  segue.destination as? TabItemViewController else {return}
        
        switch (segue.identifier) {
        case "addTabItem": tabItemViewController.displayState = .update
        default: tabItemViewController.displayState = .readOnly(selectTabItem())
        }
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
