//
//  TabRepository.swift
//  beertab
//
//  Created by Michael Neilens on 13/10/2020.
//

import Foundation

protocol TabRepositoryDelegate :WebServiceDelegate {
    func finishedGetting(tabItems:Array<TabItem>)
    func finishedPosting(tabItems:Array<TabItem>)
}

protocol TabArchiver {
    func readLatest(id:String, branch:String, delegate:TabRepositoryDelegate)
    func writeLatest(tab:Tab, delegate: TabRepositoryDelegate)
}

struct TabRepository:TabArchiver {
    let session = URLSession(configuration: URLSessionConfiguration.default)

    func readLatest(id:String, branch:String, delegate:TabRepositoryDelegate) {
        guard let url = URL(string:"https://pubcrawlapi.appspot.com/tab/\(branch)/\(id)/") else { return }
        let urlRequest = URLRequest(url: url, requestMethod: .Get, httpHeaders: nil, httpBody: nil)
        session.dataTask(with: urlRequest, completionHandler:curry(getCompletion, delegate)).resume()
    }
    
    func writeLatest(tab:Tab, delegate: TabRepositoryDelegate) {
        if let encodedTab = encode(tab: tab) {
            guard let url = URL(string:"https://pubcrawlapi.appspot.com/tab/\(tab.branch)/\(tab.id)/") else { return }
            let urlRequest = URLRequest(url: url, requestMethod: .Post, httpHeaders:["tab":encodedTab], httpBody: nil)
            session.dataTask(with: urlRequest, completionHandler:curry(postCompletion, delegate)).resume()
        }
    }
    
    func getCompletion(data:Data?, response:URLResponse?, error:Error?, delegate:TabRepositoryDelegate) {
        if let error = error {print("Invalid response \(error)");return}
        guard let data = data else {print("No Data");return}
        let tabItems = decode(data: data)
        DispatchQueue.main.async {
            delegate.finishedGetting(tabItems: tabItems)
        }
    }

    func postCompletion(data:Data?, response:URLResponse?, error:Error?, delegate:TabRepositoryDelegate) {
        if let error = error {print("Invalid response \(error)");return}
        guard let data = data else {print("No Data");return}
        let tabItems = decode(data: data)
        DispatchQueue.main.async {
            delegate.finishedPosting(tabItems: tabItems)
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
