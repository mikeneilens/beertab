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
        return (name.text != "" || pubName.text != "")
    }
    
    @IBAction func savePressed(_ sender: Any) {
        createTabAndAddToHistory()
        self.navigationController?.popViewController(animated: true)
    }
    
    func createTabAndAddToHistory() {
        let tab = Tab(name: (name.text ?? "" ), createTS: Date(), pubName: (pubName.text ?? ""), branch:self.branch, id: self.id, tabItems: [])
        history = history.add(tab: tab)
        history.save(key:archiveKey, errorResponse: errorWritingHistory(history:message:))
    }
    
    func errorWritingHistory(history:History, message:String) {
        print("error writing history: \(message)")
    }
}

extension TabViewController:ListOfPubsCreatorDelegate {
    func getPubs(location:Location) {
        let listOfPubsCreator = ListOfPubsCreator(withDelegate: self)
        listOfPubsCreator.createList(usingSearchString: "nearby", location: Location(lng:location.lng,lat:location.lat))
    }
    
    func finishedCreating(listOfPubHeaders: ListOfPubs) {
        if let pub = listOfPubHeaders.pubHeaders.first {
            suggestPub(pub: pub)
        }
    }
    
    func suggestPub(pub:PubHeader) {
        let deleteAlert = UIAlertController(title: "Pub Found", message: "Would you like to create a tab for \(pub.name) ?", preferredStyle: UIAlertController.Style.alert)

        deleteAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.pubName.text = pub.name
            self.branch = pub.branch
            self.id = pub.id
            self.saveButton.isEnabled = self.shouldSaveButtonBeEnabled()
        }))

        deleteAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler:nil))

        present(deleteAlert, animated: true, completion: nil)
    }
}
