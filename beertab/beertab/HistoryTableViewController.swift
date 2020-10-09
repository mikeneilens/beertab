//
//  HistoryTableViewController.swift
//  beertab
//
//  Created by Michael Neilens on 04/10/2020.
//

import UIKit

var history = History(allTabs: [])
var userId = UId()

class HistoryTableViewController: AbstractTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        userId.refreshUId()
        HistoryArchive().read(historyResponse: historyRead(newHistory:), errorResponse: errorReadingHistory(message:))
    }

    func historyRead(newHistory:History) {
        history = newHistory
    }
    func errorReadingHistory(message:String) {
        print("error reading history: \(message)")
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
        return history.tabs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tab = history.tabs[indexPath.row]
        
        if tab.name.isEmpty || tab.pubName.isEmpty {
            return setupSingleLabelCell(tab: tab, cell:tableView.dequeueReusableCell(withIdentifier: "tab1Cell", for: indexPath))
            
        } else {
            return setupTwoLabelCell(tab: tab, cell:tableView.dequeueReusableCell(withIdentifier: "tab1Cell", for: indexPath))
        }
    }
    
    func setupSingleLabelCell(tab:Tab, cell:UITableViewCell) -> UITableViewCell {
        if let tabTableViewCell = cell as? Tab1TableViewCell {
            if tab.name.isEmpty {
                tabTableViewCell.name.text = tab.pubName
            } else {
                tabTableViewCell.name.text = tab.name
            }
            tabTableViewCell.date.text = tab.dateString
        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func setupTwoLabelCell(tab:Tab, cell:UITableViewCell) -> UITableViewCell {
        if let tabTableViewCell = cell as? Tab2TableViewCell {
            tabTableViewCell.name.text = tab.name
            tabTableViewCell.pubName.text = tab.pubName
            tabTableViewCell.date.text = tab.dateString
        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedRow = tableView.indexPathForSelectedRow?.row else {return}
        setPropertiesOf(segue.destination, row:selectedRow)
    }
    
    func setPropertiesOf(_ destination: UIViewController, row: Int) {
        if let tabItemsTableViewController = destination as? TabItemsTableViewController {
            tabItemsTableViewController.tab = history.tabs[row]
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteTab(indexPath: indexPath)
        }
    }
    
    func deleteTab(indexPath:IndexPath) {
        let tab = history.tabs[indexPath.row]
        
        let deleteAlert = UIAlertController(title: "Are You Sure", message: "Do you want to delete \(tab.name) \(tab.pubName) (\(tab.dateString))", preferredStyle: UIAlertController.Style.alert)

        deleteAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.deleteTab(tab: tab)
            self.tableView.deleteRows(at:[indexPath], with: .fade)
        }))

        deleteAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler:nil))

        present(deleteAlert, animated: true, completion: nil)
    }
    
    func deleteTab(tab: Tab) {
        history = history.remove(tab: tab)
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
