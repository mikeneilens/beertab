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
        if listOfPubHeaders.pubHeaders.count > 0 {
            present(createSugegstionAlert(pubs:listOfPubHeaders), animated: true, completion: nil)
        }
    }
    
    func createSugegstionAlert(pubs: ListOfPubs) -> UIAlertController {
        let pubSuggestionAlert = UIAlertController(title: "Pubs Found", message: "Would you like a tab for any of these premises?", preferredStyle: UIAlertController.Style.alert)

        pubs.pubHeaders.prefixNoMoreThan(3).forEach{ pub in
            pubSuggestionAlert.addAction(UIAlertAction(title: "\(pub.name)", style: .default, handler: { (action: UIAlertAction!) in
                self.updatePubDetails(pub: pub)
            }))
        }
        pubSuggestionAlert.addAction(UIAlertAction(title: "No thanks", style: .cancel, handler:nil))
        return pubSuggestionAlert
    }
    
    func updatePubDetails(pub:PubHeader) {
        self.pubName.text = pub.name
        self.branch = pub.branch
        self.id = pub.id
        self.saveButton.isEnabled = self.shouldSaveButtonBeEnabled()
    }
}

extension Array {
    func prefixNoMoreThan(_ quantity:Int) -> ArraySlice<Element> {
        let maxQuantity = (quantity < count ? quantity : count )
        return prefix(upTo:maxQuantity)
    }
}

