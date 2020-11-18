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
        if let encodedTab = encode(tab: tab) {
            guard let url = URL(string:"\(K.URL.tabURL)\(tab.branch)/\(tab.id)/") else { return }
            let urlRequest = URLRequest(url: url, requestMethod: .Post, httpHeaders:["tab":encodedTab], httpBody: nil)
            connector.send(request: urlRequest, completionHandler:readCompletion <<== completion)
        }
    }
    
    func readCompletion(data:Data?, response:URLResponse?, error:Error?, completion:@escaping (Array<TabItem>) -> ()) {
        if let error = error {print("Invalid response \(error)");return}
        guard let data = data else {print("No Data");return}
        let tabItems = decode(data: data)
        DispatchQueue.main.async {
            completion(tabItems)
        }
    }

    func writeCompletion(data:Data?, response:URLResponse?, error:Error?, completion:@escaping (Array<TabItem>) -> ()) {
        if let error = error {print("Invalid response \(error)");return}
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
            return tabItems.map { return create(fromTabItemJson: $0)}
        } else { return [] }
    } catch { return [] }
}

func create(fromTabItemJson tabItemJson:[String : Any]) -> TabItem {
    let brewer = tabItemJson["brewer"] as? String ?? ""
    let name = tabItemJson["name"]  as? String ?? ""
    let size = tabItemJson["size"] as? String ?? ""
    let price =  tabItemJson["price"] as? Int ?? 0
    return TabItem(brewer: brewer, name: name, size: size, price: price)
}

func encode(tab:Tab) -> String? {
    let encoder = JSONEncoder()
    do {let encoded = try encoder.encode(tab)
        return String(data: encoded, encoding: .utf8)
    } catch {
        print("couldn't encode tab \(tab)")
        return nil
    }
}
