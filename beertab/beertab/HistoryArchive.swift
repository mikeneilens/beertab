//
//  HistoryArchive.swift
//  beertab
//
//  Created by Michael Neilens on 06/10/2020.
//

import Foundation

protocol HistoryArchiver {
    func write(history:History, errorResponse:(History,String)->())
    func read(historyResponse: (History) -> (),  errorResponse: (String) -> ())
}

struct HistoryArchive:HistoryArchiver {
    let key:String
    func write(history: History, errorResponse: (History, String) -> ()) {
        let encoder = JSONEncoder()
        do {let encoded = try encoder.encode(history)
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: key)
        } catch {
            errorResponse(history,"error encoding History")
        }
    }
    func read(historyResponse: (History) -> (),  errorResponse: (String) -> ())  {
        let defaults = UserDefaults.standard
        
        if let savedHistory = defaults.object(forKey: key) as? Data {
            let decoder = JSONDecoder()
            do { let history = try decoder.decode(History.self, from: savedHistory)
                historyResponse(history)
            } catch {
                errorResponse("error decoding History")
            }
        } else {
            historyResponse(History(allTabs:[]))
        }
    }
}
