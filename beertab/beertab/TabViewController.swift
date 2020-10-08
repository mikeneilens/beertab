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
    
    override func viewDidLoad() {
        name.delegate = self
        pubName.delegate = self
        super.viewDidLoad()
        setDoneButtonState()
        // Do any additional setup after loading the view.
    }

    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        setDoneButtonState()
    }
    
    func setDoneButtonState() {
        if name.text == "" && pubName.text == "" {
            doneButton.isEnabled = false
        } else {
            doneButton.isEnabled = true
        }
    }
    
    @IBAction func donePressed(_ sender: Any) {
        let tab = Tab(name: (name.text ?? "" ), createTS: Date(), pubName: (pubName.text ?? ""), branch:"", id: "", tabItems: [])
        history = history.add(tab: tab)
        history.save(errorResponse: errorWritingHistory(history:message:))
        self.navigationController?.popViewController(animated: true)
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
