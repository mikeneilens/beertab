//
//  TabViewController.swift
//  beertab
//
//  Created by Michael Neilens on 04/10/2020.
//

import UIKit

class TabViewController: AbstractViewController, UITextFieldDelegate {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var pubName: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var historyRepository:HistoryArchiver = HistoryRepository()
    var pubsRepository:PubsArchive = PubsRepository()
    var locationStatus = LocationStatus.NotSet
    var branch = ""
    var id = ""
    
    override func viewDidLoad() {
        name.delegate = self
        pubName.delegate = self
        super.viewDidLoad()
        saveButton.isEnabled = shouldSaveButtonBeEnabled()
        
        getPubIfLocationIsSet()
    }

    func getPubIfLocationIsSet() {
        if case .Set(let location) = locationStatus {
            getPubs(location: location)
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        saveButton.isEnabled = shouldSaveButtonBeEnabled()
    }
    
    func shouldSaveButtonBeEnabled() -> Bool {
        (name.text != "" || pubName.text != "")
    }
    
    @IBAction func savePressed(_ sender: Any) {
        createTabAndAddToHistory()
        self.navigationController?.popViewController(animated: true)
    }
    
    func createTabAndAddToHistory() {
        let tab = Tab(name: (name.text ?? "" ), createTS: Date(), pubName: (pubName.text ?? ""), branch:self.branch, id: self.id, tabItems: [])
        history = history.add(tab: tab)
        historyRepository.write(history, errorResponse: nil)
    }
}

extension TabViewController {
    func getPubs(location:Location) {
        pubsRepository.readPubsNearBy(location: location, onCompletion: finishedCreating)
    }
    
    func finishedCreating(listOfPubHeaders: ListOfPubs) {
        if listOfPubHeaders.pubHeaders.count > 0 {
            present(createSugegstionAlert(pubs:listOfPubHeaders), animated: true, completion: nil)
        }
    }
    
    func createSugegstionAlert(pubs: ListOfPubs) -> UIAlertController {
        return UIAlertController(title: "Pubs Found", message: "Would you like a tab for any of these premises?", preferredStyle: .alert
        ).apply{this in
            pubs.pubHeaders.prefixNoMoreThan(3).forEach{ pub in
                this.addAction(UIAlertAction(title: "\(pub.name)", style: .default, handler: { (action: UIAlertAction!) in
                    self.updatePubDetails(pub: pub)
                }))
            }
            this.addAction(UIAlertAction(title: "No thanks", style: .cancel, handler:nil))
        }
    }
    
    func updatePubDetails(pub:PubHeader) {
        self.pubName.text = pub.name
        self.branch = pub.branch
        self.id = pub.id
        self.saveButton.isEnabled = self.shouldSaveButtonBeEnabled()
    }
}


