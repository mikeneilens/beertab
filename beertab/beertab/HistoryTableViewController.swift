//
//  HistoryTableViewController.swift
//  beertab
//
//  Created by Michael Neilens on 04/10/2020.
//

import UIKit
import CoreLocation

var history = History(allTabs: [])
var bills:Array<Bill> = []

class HistoryTableViewController: AbstractTableViewController {
    
    var historyRepository:HistoryArchiver = HistoryRepository()
    var userOptionsRepository:UserOptionsArchiver = UserOptionsRepository()
    let locationManager = CLLocationManager()
    var currentLocation = LocationStatus.NotSet
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        retrieveHistory()
        startLocationServices()
    }
    
    func startLocationServices() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 100000), execute: startUpdatingLocation)
    }
    
    func retrieveHistory() {
        self.historyRepository.read(historyResponse: self.historyRead(newHistory:), errorResponse: nil)
    }
    
    func tabFor(indexPath:IndexPath) -> Tab {
        history.tabsByDate[indexPath.section].tabs[indexPath.row]
    }

    /*
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status:CLAuthorizationStatus) {
        if (status == .authorizedAlways || status == .authorizedWhenInUse) {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    locationManager.startUpdatingLocation()
                }
            }
        }
    }
     */

/*
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
 */
    func historyRead(newHistory:History) {
        history = newHistory
        if history.allTabs.isEmpty && instructionsShouldBePresented() {
            showInstructions()
        }
    }
    
    func instructionsShouldBePresented()-> Bool {
        !userOptionsRepository.isSet(for: "HistoryHelp" )
    }

    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        history.tabsByDate.count
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
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        indexPath.row < history.tabsByDate[indexPath.section].tabs.count
    }
    
    func setupSingleLabelCell(tab:Tab, cell:UITableViewCell) -> UITableViewCell {
        guard let tabTableViewCell = cell as? Tab1TableViewCell else {return cell}
        
        return tabTableViewCell.apply{
            $0.setNameAndTotal(name: tab.name, pubName: tab.pubName, total: tab.totalValue)
            $0.accessoryType = .disclosureIndicator
        }
    }

    func setupTwoLabelCell(tab:Tab, cell:UITableViewCell) -> UITableViewCell {
        guard let tabTableViewCell = cell as? Tab2TableViewCell else {return cell}
        
        return tabTableViewCell.apply{
            $0.setNameAndTotal(name: tab.name, pubName: tab.pubName, total: tab.totalValue)
            $0.accessoryType = .disclosureIndicator
        }
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
            case let tabItemsTableViewController as TabItemsTableViewController:
                tabItemsTableViewController.tab = tabFor(indexPath: indexPath)
            case let tabViewController as TabViewController:
                tabViewController.locationStatus = currentLocation
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
        UIAlertController(title: "Are You Sure", message: "Do you want to delete \(tab.name) \(tab.pubName) (\(tab.dateString))", preferredStyle:.alert
        ).apply{this in
            this.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_: UIAlertAction!) in
                self.deleteTab(tab: tab)
                self.tableView.reloadData()
            }))
            this.addAction(UIAlertAction(title: "No", style: .cancel, handler:nil))
        }
    }
    
    func deleteTab(tab: Tab) {
        history = history.remove(tab: tab)
        historyRepository.write(history, errorResponse: nil)
    }
    
    func showInstructions() {
        let alert = createInstructionsAlert()
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    func createInstructionsAlert() -> UIAlertController {
        UIAlertController(title: "", message: "You don't seem to have created any visits. Press the + button in the top right hand corner to create a visit. If you have allowed this application to use your location the nearest bar will be automatically located.", preferredStyle: .alert
        ).apply{this in
            this.addAction(UIAlertAction(title: NSLocalizedString("Don't show again", comment: "Default action"), style: .default, handler: disableInstructions))
            this.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
        }
    }
    
    func disableInstructions(_: UIAlertAction) {
        userOptionsRepository.set("HistoryHelp", value: "No")
    }
}

extension HistoryTableViewController: CLLocationManagerDelegate { //delegat methods for CLLoctaionManager
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        if (manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse) {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startUpdatingLocation()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = manager.location?.coordinate else {return}
        self.currentLocation = .Set(location:  Location(fromCoordinate:coordinate))
    }
    
    func startUpdatingLocation(){
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
}
