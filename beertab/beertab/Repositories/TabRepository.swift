//
//  TabRepository.swift
//  beertab
//
//  Created by Michael Neilens on 13/10/2020.
//

import Foundation

protocol TabArchiver {
    func readLatest(id:String, branch:String, onCompletion completion:@escaping(Array<TabItem>) -> ())
    func writeLatest(tab:Tab, onCompletion completion:@escaping (Array<TabItem>) -> () )
}

struct TabRepository:TabArchiver {
    var connector:HTTPConnector = Connector()

    func readLatest(id:String, branch:String, onCompletion completion:@escaping (Array<TabItem>) -> ()) {
        guard let url = URL(string:"\(K.URL.tabURL)\(branch)/\(id)/") else { return }
        let urlRequest = URLRequest(url: url, requestMethod: .Get, httpHeaders: nil, httpBody: nil)
        connector.send(request: urlRequest, completionHandler:readCompletion <<== completion)
    }
    
    func writeLatest(tab:Tab, onCompletion completion:@escaping (Array<TabItem>) -> () ) {
        if let encodedTab = tab.encode() {
            guard let url = URL(string:"\(K.URL.tabURL)\(tab.branch)/\(tab.id)/") else { return }
            let urlRequest = URLRequest(url: url, requestMethod: .Post, httpHeaders:["tab":encodedTab], httpBody: nil)
            connector.send(request: urlRequest, completionHandler:readCompletion <<== completion)
        }
    }
    
    func readCompletion(data:Data?, response:URLResponse?, error:Error?, completion:@escaping (Array<TabItem>) -> ()) {
        if let error {print("Invalid response \(error)");return}
        guard let data = data else {print("No Data");return}
        let tabItems = decode(data: data)
        DispatchQueue.main.async {
            completion(tabItems)
        }
    }

    func writeCompletion(data:Data?, response:URLResponse?, error:Error?, completion:@escaping (Array<TabItem>) -> ()) {
        if let error {print("Invalid response \(error)");return}
        guard let data = data else {print("No Data");return}
        let tabItems = decode(data: data)
        DispatchQueue.main.async {
            completion(tabItems)
        }
    }
}

func decode(data:Data) -> Array<TabItem> {
    do {
        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
            let tabItems = json["tabItems"] as? [[String:Any]] ?? []
            return tabItems.map { return TabItem(fromJson: $0)}
        } else { return [] }
    } catch { return [] }
}
