//
//  HistoryArchive.swift
//  beertab
//
//  Created by Michael Neilens on 06/10/2020.
//

import Foundation

protocol HistoryArchiver {
    func write(_ history:History, errorResponse:Optional<(History,String)->()>)
    func read(historyResponse: @escaping (History) -> (), errorResponse: Optional<(String) -> ()>)
}

struct HistoryRepository:HistoryArchiver {
    let key:String
    init (key:String = "history") {
        self.key = key
    }
    
    func write(_ history: History, errorResponse: Optional<(History, String) -> ()>) {
        DispatchQueue.main.async {
            writeToUserDefaults(UserDefaults.standard, history, errorResponse)
        }
    }
    
    func writeToUserDefaults(_ defaults: UserDefaults, _ history: History,  _ errorResponse: ((History, String) -> ())?) {
        let encoder = JSONEncoder()
        do {let encoded = try encoder.encode(history)
            defaults.set(encoded, forKey: key)
        } catch {
            print("error encoding History")
            if let errorResponse = errorResponse {errorResponse(history,"error encoding History")}
        }
    }
    
    func read(historyResponse: @escaping (History) -> (),  errorResponse: Optional<(String) -> ()>)  {
        DispatchQueue.main.async {
          readUserDefaults(UserDefaults.standard, historyResponse, errorResponse)
        }
    }
    
    func readUserDefaults(_ defaults: UserDefaults, _ historyResponse: (History) -> (), _ errorResponse: ((String) -> ())?) {
        if let savedHistory = defaults.object(forKey: key) as? Data {
            let decoder = JSONDecoder()
            do { let history = try decoder.decode(History.self, from: savedHistory)
                historyResponse(history)
            } catch {
                print("error decoding history")
                if let errorResponse = errorResponse{errorResponse("error decoding History")}
            }
        } else {
            historyResponse(History(allTabs:[]))
        }
    }
}
