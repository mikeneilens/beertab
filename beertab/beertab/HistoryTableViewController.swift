//
//  HistoryTableViewController.swift
//  beertab
//
//  Created by Michael Neilens on 04/10/2020.
//

import UIKit
import CoreLocation

var history = History(allTabs: [])
var archiveKey = "history"

class HistoryTableViewController: AbstractTableViewController {
    
    let locationManager = CLLocationManager()
    var currentLocation = LocationStatus.NotSet
    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkLocationServicesPermissions()
        locationManager.delegate = self
        HistoryArchive(key:archiveKey).read(historyResponse: historyRead(newHistory:), errorResponse: errorReadingHistory(message:))
    }
    
    func tabFor(indexPath:IndexPath) -> Tab {
        let tabByDate = history.tabsByDate[indexPath.section]
        return tabByDate.tabs[indexPath.row]
    }
    
    func checkLocationServicesPermissions() {
        if CLLocationManager.locationServicesEnabled() {
            let authorisationStatus = CLLocationManager.authorizationStatus()
            if authorisationStatus == .authorizedAlways || authorisationStatus == .authorizedWhenInUse {
                locationManager.startUpdatingLocation()
            } else {
                self.locationManager.requestWhenInUseAuthorization()
            }
        }
    }
    func historyRead(newHistory:History) {
        history = newHistory
        if history.allTabs.isEmpty && instructionsShouldBePresented() {
            showInstructions()
        }
    }
    
    func instructionsShouldBePresented()-> Bool {
        if let _ = UserDefaults.standard.object(forKey: "HistoryHelp") {return false}
        else {return true}
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
        return history.tabsByDate.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if history.tabsByDate[section].tabs.count > 1 {
            return history.tabsByDate[section].tabs.count + 1
        } else {
            return history.tabsByDate[section].tabs.count
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return history.tabsByDate[section].date
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row >= history.tabsByDate[indexPath.section].tabs.count {
            return setupHistoryTotalCell(section:indexPath.section, cell:tableView.dequeueReusableCell(withIdentifier: "totalCell", for: indexPath))
        }
        let tab = tabFor(indexPath: indexPath)
        if tab.name.isEmpty || tab.pubName.isEmpty {
            return setupSingleLabelCell(tab: tab, cell:tableView.dequeueReusableCell(withIdentifier: "tab1Cell", for: indexPath))
        } else {
            return setupTwoLabelCell(tab: tab, cell:tableView.dequeueReusableCell(withIdentifier: "tab2Cell", for: indexPath))
        }
    }
    
    func setupSingleLabelCell(tab:Tab, cell:UITableViewCell) -> UITableViewCell {
        if let tabTableViewCell = cell as? Tab1TableViewCell {
            tabTableViewCell.name.text = tab.name.isEmpty ? tab.pubName : tab.name
            tabTableViewCell.total.text = tab.totalValue
        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func setupTwoLabelCell(tab:Tab, cell:UITableViewCell) -> UITableViewCell {
        if let tabTableViewCell = cell as? Tab2TableViewCell {
            tabTableViewCell.name.text = tab.name
            tabTableViewCell.pubName.text = tab.pubName
            tabTableViewCell.total.text = tab.totalValue
        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func setupHistoryTotalCell(section:Int, cell:UITableViewCell) -> UITableViewCell {
        if let totalTableViewCell = cell as? HistoryTotalTableViewCell {
            let total = history.tabsByDate[section].tabs.map{$0.totalPence}.reduce(0){$0 + $1}.priceGBP
            totalTableViewCell.totalLabel.text = "Total £\(total)"
        }
        return cell
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPathForSelectedRow ?? IndexPath(row: 0, section: 0)
        setPropertiesOf(segue.destination, indexPath: indexPath)
    }
    
    func setPropertiesOf(_ destination: UIViewController, indexPath: IndexPath) {
        switch destination {
            case let tabItemsTableViewController as TabItemsTableViewController: tabItemsTableViewController.tab = tabFor(indexPath: indexPath)
            case let tabViewController as TabViewController: tabViewController.locationStatus = currentLocation
            default: break
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteTab(indexPath: indexPath)
        }
    }
    
    func deleteTab(indexPath:IndexPath) {
        let tab = tabFor(indexPath: indexPath)
        self.navigationController?.present(deleteTabAlert(for: tab), animated: true, completion: nil)
    }
    
    func deleteTabAlert(for tab: Tab) -> UIAlertController {
        return UIAlertController(title: "Are You Sure", message: "Do you want to delete \(tab.name) \(tab.pubName) (\(tab.dateString))", preferredStyle:.alert
        ).apply{this in
            this.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                self.deleteTab(tab: tab)
                self.tableView.reloadData()
            }))
            this.addAction(UIAlertAction(title: "No", style: .cancel, handler:nil))
        }
    }
    
    func deleteTab(tab: Tab) {
        history = history.remove(tab: tab)
        history.save(key:archiveKey, errorResponse: errorWritingHistory(history:message:))
    }
    
    func errorWritingHistory(history:History, message:String) {
        print("error writing history: \(message)")
    }
    
    func showInstructions() {
        let alert = createInstructionsAlert()
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    func createInstructionsAlert() -> UIAlertController {
        return UIAlertController(title: "", message: "You don't seem to have created any visits. Press the + button in the top right hand corner to create a visit. If you have allowed this application to use your location the nearest bar will be automatically located.", preferredStyle: .alert
        ).apply{this in
            this.addAction(UIAlertAction(title: NSLocalizedString("Don't show again", comment: "Default action"), style: .default, handler: disableInstructions))
            this.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
        }
    }
    
    func disableInstructions(_: UIAlertAction) {
        UserDefaults.standard.set("No", forKey: "HistoryHelp")
    }
}

extension HistoryTableViewController: CLLocationManagerDelegate { //delegat methods for CLLoctaionManager
    
    func locationManager(_ manager:CLLocationManager, didChangeAuthorization status:CLAuthorizationStatus) {
        if ((status == .authorizedAlways) || (status == .authorizedWhenInUse)) {
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue = manager.location!.coordinate
        self.currentLocation = .Set(location:  Location(fromCoordinate:locValue))
    }
}
