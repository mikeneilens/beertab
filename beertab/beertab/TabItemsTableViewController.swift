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
    
    var historyRepository:HistoryArchiver = HistoryRepository()
    var userOptionsRepository:UserOptionsArchiver = UserOptionsRepository()
    var tabRepository:TabArchiver = TabRepository()
    var billRepository:BillArchiver = BillRepository()
    var tab = Tab(name: "", createTS: Date(), pubName: "", branch: "", id: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = navigationTitle(for: tab)
        if (tab.tabItems.isEmpty) {
            if !tab.branch.isEmpty && !tab.id.isEmpty  {
                tabRepository.readLatest(id: tab.id, branch: tab.branch, onCompletion: finishedReading)
            } else {
                showInsructionsIfRequired() 
            }
        }
    }

    func navigationTitle(for tab:Tab) -> String {
        tab.pubName.isEmpty ? tab.name : tab.pubName
    }
    
    func instructionsShouldBePresented()-> Bool {
        !userOptionsRepository.isSet(for: "TabItemHelp")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        tab.tabItems.isEmpty ? 1 : 2
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
            if (tab.tabItems[indexPath.row].brewer.isEmpty || tab.tabItems[indexPath.row].name.isEmpty) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "tabItem2Cell", for: indexPath)
                configureTabItem2Cell(cell, indexPath)
                return cell

            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "tabItemCell", for: indexPath)
                configureTabItemCell(cell, indexPath)
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tabTotalCell", for: indexPath)
            configureSummaryCell(cell)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        indexPath.section == 0
    }
    
    func configureTabItemCell(_ cell: UITableViewCell, _ indexPath: IndexPath) {
        guard let tabItemCell = cell as? TabItemTableViewCell else {return}
        tabItemCell.brewer.text = tab.tabItems[indexPath.row].brewer
        tabItemCell.name.text = tab.tabItems[indexPath.row].name
        tabItemCell.size.text = "\(tab.tabItems[indexPath.row].size) £\(tab.tabItems[indexPath.row].priceGBP)"
        tabItemCell.quantity.text = String(tab.tabItems[indexPath.row].quantity)
    }

    func configureTabItem2Cell(_ cell: UITableViewCell, _ indexPath: IndexPath) {
        guard let tabItemCell = cell as? TabItem2TableViewCell else {return}
        if (!tab.tabItems[indexPath.row].brewer.isEmpty) {
            tabItemCell.name.text = tab.tabItems[indexPath.row].brewer
        } else {
            tabItemCell.name.text = tab.tabItems[indexPath.row].name
        }
        tabItemCell.size.text = "\(tab.tabItems[indexPath.row].size) £\(tab.tabItems[indexPath.row].priceGBP)"
        tabItemCell.quantity.text = String(tab.tabItems[indexPath.row].quantity)
    }
 
    func configureSummaryCell(_ cell: UITableViewCell) {
          if let tabTotalCell = cell as? TabTotalTableViewCell {
              tabTotalCell.totalValue.text = tab.totalValue
          }
    }
      
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 60
        } else {
            return 44
        }
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            if tab.tabItems.isEmpty {
                return "You have no items on your tab"
            } else {
                return "Items"
            }
        } else {
            return "Your Total Bill"
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteTabItem(indexPath: indexPath)
        }
    }
    
    func deleteTabItem(indexPath:IndexPath) {
        let tabItem = tab.tabItems[indexPath.row]
        present(createDeleteAlert(tabItem: tabItem), animated: true, completion: nil)
    }
    
    func createDeleteAlert(tabItem:TabItem) -> UIAlertController {
        return UIAlertController(title: "Are You Sure", message: "Do you want to delete \(tabItem.brewer) \(tabItem.name) (\(tabItem.size))", preferredStyle: .alert).apply { this in
                this.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                    self.deleteTabItem(tabItem: tabItem)
                    self.tableView.reloadData()
                }))
                this.addAction(UIAlertAction(title: "No", style: .cancel, handler:nil))
        }
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
        tabItemUpdateViewController.tabItem = selectTabItem(selectedRow:row)
        tabItemUpdateViewController.position = (row ?? 0)
        tabItemUpdateViewController.tabUpdater = self
    }
    
    func prepare(_ receiptViewController:ReceiptViewController) {
        receiptViewController.tab = tab
    }
    func selectTabItem(selectedRow:Int?) -> TabItem {
        if let selectedRow {
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
        historyRepository.write(history, errorResponse: nil)
        writeTabToRepository(tab: tab)
    }
    
    func writeTabToRepository(tab:Tab) {
        if tab.branch != "" && tab.id != "" {
            tabRepository.writeLatest(tab: tab, onCompletion: finishedWriting)
        }
    }
    
    func buyTabItem(tabItem: TabItem) {
        tab = tab.addTransaction(brewer: tabItem.brewer, name: tabItem.name, size: tabItem.size)
        history = history.update(tab: tab)
        historyRepository.write(history, errorResponse: nil)
        billRepository.createOrUpdateBill(tab: tab, onCompletion:{_ in}, errorResponse: nil)
    }
    
    func returnTabItem(tabItem: TabItem) {
        tab = tab.removeTransaction(brewer: tabItem.brewer, name: tabItem.name, size: tabItem.size)
        history = history.update(tab: tab)
        historyRepository.write(history, errorResponse: nil)
        billRepository.createOrUpdateBill(tab: tab, onCompletion:{_ in}, errorResponse: nil)
    }
    func deleteTabItem(tabItem: TabItem) {
        tab = tab.remove(tabItem: tabItem)
        history = history.update(tab: tab)
        historyRepository.write(history, errorResponse: nil)
        billRepository.createOrUpdateBill(tab: tab, onCompletion:{_ in}, errorResponse: nil)
    }
    func replaceTabItem(position:Int, newTabItem:TabItem) {
        tab = tab.replace(position: position, newTabItem: newTabItem)
        history = history.update(tab: tab)
        historyRepository.write(history, errorResponse: nil)
        writeTabToRepository(tab: tab)
        billRepository.createOrUpdateBill(tab: tab, onCompletion:{_ in}, errorResponse: nil)
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
        self.navigationController?.present(createInstructions(), animated: true, completion: nil)
    }
    
    func createInstructions() -> UIAlertController {
        UIAlertController(title: "", message: "You don't seem to have added any items to the tab for this visit. To create a new item press the + button in the top right hand corner. ", preferredStyle: .alert
        ).apply{ this in
            this.addAction(UIAlertAction(title: NSLocalizedString("Don't show again", comment: "Default action"), style: .default, handler: disableInstructions(_:)))
            this.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
        }
    }
    
    func disableInstructions(_: UIAlertAction) {
        userOptionsRepository.set("TabItemHelp", value: "No")
    }
}

extension TabItemsTableViewController {
    
    func finishedReading(tabItems: Array<TabItem>) {
        if tabItems.count > 0 {
            suggestTabItems(tabItems: tabItems)
        } else {
            showInsructionsIfRequired()
        }
    }
    
    func suggestTabItems(tabItems:Array<TabItem>) {
        self.navigationController?.present(createTabItemsAlert(tabItems:tabItems), animated: true, completion: nil)
    }
    
    func createTabItemsAlert(tabItems: Array<TabItem>) -> UIAlertController {
        return UIAlertController(title: "Items Found for \(tab.pubName).", message: "Would you like to automatically add some items ?", preferredStyle: .alert).apply{ this in
            this.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in self.updateTab(tabItems: tabItems)}))
            this.addAction(UIAlertAction(title: "No", style: .cancel, handler:{_ in self.showInsructionsIfRequired()}))
        }
    }
    
    func updateTab(tabItems:Array<TabItem>) {
        self.addTabItems(tabItems: tabItems)
        self.tableView.reloadData()
    }
    
    func finishedWriting(tabItems: Array<TabItem>) {
    }
}

