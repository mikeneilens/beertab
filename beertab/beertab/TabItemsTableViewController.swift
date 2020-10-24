//
//  TabItemsTableViewController.swift
//  beertab
//
//  Created by Michael Neilens on 04/10/2020.
//

import UIKit

protocol TabUpdater {
    func addTabItems(tabItems:Array<TabItem>)
    func buyTabItem(tabItem:TabItem)
    func returnTabItem(tabItem:TabItem)
    func deleteTabItem(tabItem:TabItem)
    func replaceTabItem(position:Int, newTabItem:TabItem)
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
        
        if (tab.tabItems.count == 0) {
            if !tab.branch.isEmpty && !tab.id.isEmpty  {
                TabReader(delegate: self, errorDelegate: self).getLatest(id: tab.id, branch: tab.branch)
            } else {
                showInsructionsIfRequired() 
            }
        }
    }

    func instructionsShouldBePresented()-> Bool {
        if let _ = UserDefaults.standard.object(forKey: "TabItemHelp") {return false}
        else {return true}
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if tab.tabItems.isEmpty {
            return 1
        } else {
            return 2
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
            //tabItemCell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        }
    }
    
    func configureSummaryCell(_ cell: UITableViewCell) {
          if let tabTotalCell = cell as? TabTotalTableViewCell {
              tabTotalCell.totalValue.text = tab.totalValue
              //tabTotalCell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
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
            self.tableView.reloadData()
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
        case let receiptViewController as ReceiptViewController : prepare(receiptViewController)
        default: break
        }
    }

    func prepare(_ tabItemAddViewController:TabItemAddViewController) {
        tabItemAddViewController.tabUpdater = self
    }
    
    func prepare(_ tabItemUpdateViewController:TabItemUpdateViewController, row:Int?) {
        tabItemUpdateViewController.tabItem = selectTabItem(row:row)
        tabItemUpdateViewController.position = (row ?? 0)
        tabItemUpdateViewController.tabUpdater = self
    }
    
    func prepare(_ receiptViewController:ReceiptViewController) {
        receiptViewController.tab = tab
    }
    func selectTabItem(row:Int?) -> TabItem {
        if let selectedRow = row {
            return tab.tabItems[selectedRow]
        }
        else {
            return TabItem(brewer: "", name: "", size: "", price: 0)
        }
    }
    
    func addTabItems(tabItems:Array<TabItem>)  {
        tabItems.forEach{ tabItem in
            tab = tab.add(tabItem: tabItem)
            history = history.update(tab: tab)
        }
        history.save(key:archiveKey, errorResponse: errorWritingHistory(history:message:))
        writeTabToRepository(tab: tab)
    }
    
    func writeTabToRepository(tab:Tab) {
        if tab.branch != "" && tab.id != "" {
            TabWriter(delegate: self, errorDelegate: self).post(tab: tab)
        }
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
    func replaceTabItem(position:Int, newTabItem:TabItem) {
        tab = tab.replace(position: position, newTabItem: newTabItem)
        history = history.update(tab: tab)
        history.save(key:archiveKey, errorResponse: errorWritingHistory(history:message:))
        writeTabToRepository(tab: tab)
    }
    func errorWritingHistory(history:History, message:String) {
        print("error writing history: \(message)")
    }
    
    func showInsructionsIfRequired() {
        if instructionsShouldBePresented() {
            showInstructions()
        }
    }

    func showInstructions() {
        let alert = UIAlertController(title: "", message: "You don't seem to have added any items to the tab for this visit. To create a new item press the + button in the top right hand corner. ", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Don't show again", comment: "Default action"), style: .default, handler: {_ in
            UserDefaults.standard.set("No", forKey: "TabItemHelp")
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
        }))
        
        self.navigationController?.present(alert, animated: true, completion: nil)

    }
}

extension TabItemsTableViewController:TabRepositoryDelegate {
    
    func finishedGetting(tabItems: Array<TabItem>) {
        if tabItems.count > 0 {
            suggestTabItems(tabItems: tabItems)
        } else {
            showInsructionsIfRequired()
        }
    }
    
    func suggestTabItems(tabItems:Array<TabItem>) {
        let createTabItemsAlert = UIAlertController(title: "Items Found for \(tab.pubName).", message: "Would you like to automatically add some items ?", preferredStyle: UIAlertController.Style.alert)

        createTabItemsAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.updateTab(tabItems: tabItems)
        }))

        createTabItemsAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler:nil))

        present(createTabItemsAlert, animated: true, completion: nil)
    }
    
    func updateTab(tabItems:Array<TabItem>) {
        self.addTabItems(tabItems: tabItems)
        self.tableView.reloadData()
    }
    
    func finishedPosting(tabItems: Array<TabItem>) {
        print("tab items posted")
    }
}

