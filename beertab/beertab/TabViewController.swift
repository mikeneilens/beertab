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
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var locationStatus = LocationStatus.NotSet
    
    override func viewDidLoad() {
        name.delegate = self
        pubName.delegate = self
        super.viewDidLoad()
        doneButton.isEnabled = ShouldDoneButtonBeEnabled()
        // Do any additional setup after loading the view.
    }

    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        doneButton.isEnabled = ShouldDoneButtonBeEnabled()
    }
    
    func ShouldDoneButtonBeEnabled() -> Bool {
        return (name.text != "" || pubName.text != "")
    }
    
    @IBAction func donePressed(_ sender: Any) {
        createTabAndAddToHistory()
        self.navigationController?.popViewController(animated: true)
    }
    
    func createTabAndAddToHistory() {
        let tab = Tab(name: (name.text ?? "" ), createTS: Date(), pubName: (pubName.text ?? ""), branch:"", id: "", tabItems: [])
        history = history.add(tab: tab)
        history.save(key:archiveKey, errorResponse: errorWritingHistory(history:message:))
    }
    
    func errorWritingHistory(history:History, message:String) {
        print("error writing history: \(message)")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
