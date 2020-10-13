//
//  HistoryTableViewController.swift
//  beertab
//
//  Created by Michael Neilens on 04/10/2020.
//

import UIKit
import CoreLocation

var history = History(allTabs: [])
var userId = UId()
var archiveKey = "history"

class HistoryTableViewController: AbstractTableViewController {
    
    let locationManager = CLLocationManager()
    var currentLocation = LocationStatus.NotSet
    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkLocationServicesPermissions()
        locationManager.delegate = self
        userId.refreshUId()
        HistoryArchive(key:archiveKey).read(historyResponse: historyRead(newHistory:), errorResponse: errorReadingHistory(message:))
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
            return setupTwoLabelCell(tab: tab, cell:tableView.dequeueReusableCell(withIdentifier: "tab2Cell", for: indexPath))
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
        let selectedRow = tableView.indexPathForSelectedRow?.row ?? 0
        setPropertiesOf(segue.destination, row:selectedRow)
    }
    
    func setPropertiesOf(_ destination: UIViewController, row: Int) {
        switch destination {
            case let tabItemsTableViewController as TabItemsTableViewController: tabItemsTableViewController.tab = history.tabs[row]
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
        history.save(key:archiveKey, errorResponse: errorWritingHistory(history:message:))
    }
    
    func errorWritingHistory(history:History, message:String) {
        print("error writing history: \(message)")
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
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        self.currentLocation = .Set(location:  Location(fromCoordinate:locValue))
    }
}
