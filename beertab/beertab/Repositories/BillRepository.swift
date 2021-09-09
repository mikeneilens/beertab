//
//  BillRepository.swift
//  beertab
//
//  Created by Michael Neilens on 08/09/2021.
//

import Foundation

protocol BillArchiver {
    func read(tab:Tab, onCompletion completion:@escaping(Array<Bill>) -> (), errorResponse: Optional<(String) -> ()>)
    func write(tab:Tab,billId:String, onCompletion completion:@escaping (Array<Bill>) -> (), errorResponse: Optional<(String) -> ()> )
}

struct BillRepository:BillArchiver {
    
    var connector:HTTPConnector = Connector()

    func read(tab:Tab, onCompletion completion:@escaping(Array<Bill>) -> (), errorResponse: Optional<(String) -> ()>) {
        if let encodedTab = tab.encode() {
            guard let url = URL(string:"\(K.URL.billURL)?tabId=\(tab.tabId ?? "")") else { return }
            let urlRequest = URLRequest(url: url, requestMethod: .Get, httpHeaders: ["tab":encodedTab], httpBody: nil)
            connector.send(request: urlRequest, completionHandler:readCompletion <<== errorResponse <<== completion)
        }
    }
    
    func write(tab:Tab, billId: String, onCompletion completion: @escaping (Array<Bill>) -> (), errorResponse: Optional<(String) -> ()>) {
        if let encodedTab = tab.encode() {
            guard let url = URL(string:K.URL.billURL + "\(billId)/\(tab.tabId ?? "")/") else { return }
            let urlRequest = URLRequest(url: url, requestMethod: .Post, httpHeaders:["tab":encodedTab], httpBody: nil)
            connector.send(request: urlRequest, completionHandler:writeCompletion <<== errorResponse <<== completion )
        }
    }
    
    func readCompletion(data:Data?, response:URLResponse?, error:Error?, completion:@escaping (Array<Bill>) -> (), errorResponse: Optional<(String) -> ()> ) {
        let sendError = {if let errorResponse = errorResponse{ errorResponse("error obtaining Bill")} }
        
        if let error = error {
            print("Invalid response \(error)")
            sendError()
            return
        }
        
        guard let data = data else {
            print("No Data")
            sendError()
            return
        }
        
        do { let bills = try decodeBill(data: data)
        DispatchQueue.main.async {
            completion(bills)
            }
        } catch {
            print("error decoding Bill")
            sendError()
        }
    }

    func writeCompletion(data:Data?, response:URLResponse?, error:Error?, completion:@escaping (Array<Bill>) -> (), errorResponse: Optional<(String) -> ()>) {
        let sendError = {if let errorResponse = errorResponse{ errorResponse("error creating Bill")} }
        
        if let error = error {
            print("Invalid response \(error)")
            sendError()
            return
        }
        
        guard let data = data else {
            print("No Data")
            sendError()
            return
        }
                
        do { let bills = try decodeBill(data: data)
            DispatchQueue.main.async {
                completion(bills)
            }
        } catch {
            print("error decoding Bill")
            sendError()
        }
    }
}

func decodeBill(data:Data) throws -> Array<Bill>  {
    do {
        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
            let bills = json["bills"] as? [[String:Any]] ?? []
            return bills.map { return Bill(fromJson: $0)}
        } else { return [] }
    }
}
