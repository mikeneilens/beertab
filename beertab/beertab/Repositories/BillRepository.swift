//
//  BillRepository.swift
//  beertab
//
//  Created by Michael Neilens on 08/09/2021.
//

import Foundation

protocol BillArchiver {
    func createOrUpdateBill(tab:Tab, onCompletion completion:@escaping(Bill) -> (), errorResponse: Optional<(String) -> ()>)
    func updateBill(tab:Tab,billId:String, onCompletion completion:@escaping (Bill) -> (), errorResponse: Optional<(String) -> ()> )
}

struct BillRepository:BillArchiver {
    
    var connector:HTTPConnector = Connector()

    func createOrUpdateBill(tab:Tab, onCompletion completion:@escaping(Bill) -> (), errorResponse: Optional<(String) -> ()>) {
        if let encodedTab = try? JSONEncoder().encode(tab) {
            guard let url = URL(string:"\(K.URL.billURL)?tabId=\(tab.tabId ?? "")") else { return }
            let urlRequest = URLRequest(url: url, requestMethod: .Post, httpHeaders: ["Content-Type":"text/plain; charset=utf-8"], httpBody: encodedTab)
            connector.send(request: urlRequest, completionHandler:createCompletion <<== errorResponse <<== completion)
        }
    }
    
    func updateBill(tab:Tab, billId: String, onCompletion completion: @escaping (Bill) -> (), errorResponse: Optional<(String) -> ()>) {
        if let encodedTab = try? JSONEncoder().encode(tab) {
            guard let url = URL(string:K.URL.billURL + "\(billId)/\(tab.tabId ?? "")/") else { return }
            let urlRequest = URLRequest(url: url, requestMethod: .Post, httpHeaders:["Content-Type":"text/plain; charset=utf-8"], httpBody: encodedTab)
            connector.send(request: urlRequest, completionHandler:updateBillCompletion <<== errorResponse <<== completion )
        }
    }
    
    func createCompletion(data:Data?, response:URLResponse?, error:Error?, completion:@escaping (Bill) -> (), errorResponse: Optional<(String) -> ()> ) {
        let sendError = {if let errorResponse = errorResponse{
            DispatchQueue.main.async {
                errorResponse("error obtaining Bill")}
            }
        }
        
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
        
        do { let bill = try JSONDecoder().decode(Bill.self,from:data)
        DispatchQueue.main.async {
            completion(bill)
            }
        } catch {
            print("error decoding Bill")
            sendError()
        }
    }

    func updateBillCompletion(data:Data?, response:URLResponse?, error:Error?, completion:@escaping (Bill) -> (), errorResponse: Optional<(String) -> ()>) {
        let sendError = {if let errorResponse = errorResponse{
            DispatchQueue.main.async {
                errorResponse("error creating Bill")}
            }
        }
        
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
                
        do { let bill = try JSONDecoder().decode(Bill.self, from: data)
            DispatchQueue.main.async {
                completion(bill)
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
