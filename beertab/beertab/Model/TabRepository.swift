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

struct TabReader:WebServiceCallerType {
    
    let delegate:TabRepositoryDelegate
    let errorDelegate: WebServiceDelegate
    let serviceName = "obtain TabItems"
    
    func getLatest(id:String, branch:String) {
        self.call(withDelegate: self, url: "https://pubcrawlapi.appspot.com/tab/\(branch)/\(id)/")
    }
    
    func finishedGetting(json: [String : Any]) {
        if let tabItems = json["tabItems"] as? [[String:Any]] {
            let result:Array<TabItem> = tabItems.map {
                return create(fromTabItemJson: $0)
            }
            delegate.finishedGetting(tabItems: result)
        }
    }
}

struct TabWriter:WebServiceCallerType {
    
    let delegate:TabRepositoryDelegate
    let errorDelegate: WebServiceDelegate
    var serviceName = "obtain TabItems"
    
    func finishedGetting(json: [String : Any]) {
        if let tabItems = json["tabItems"] as? [[String:Any]] {
            let result:Array<TabItem> = tabItems.map {
                return create(fromTabItemJson: $0)
            }
            delegate.finishedPosting(tabItems: result)
        }
    }
    
    func post(tab:Tab) {
        let encoder = JSONEncoder()
        do {let encoded = try encoder.encode(tab)
            let data = String(data: encoded, encoding: .utf8)!
            self.post(withDelegate: self, url: "https://pubcrawlapi.appspot.com/tab/\(tab.branch)/\(tab.id)/", httpHeaders: ["tab":data])
        } catch {
            print("couldn't encode tab \(tab)")
        }
    }
}

func create(fromTabItemJson tabItemJson:[String : Any]) -> TabItem {
    let brewer = tabItemJson["brewer"] as? String ?? ""
    let name = tabItemJson["name"]  as? String ?? ""
    let size = tabItemJson["size"] as? String ?? ""
    let price =  tabItemJson["price"] as? Int ?? 0
    return TabItem(brewer: brewer, name: name, size: size, price: price)
}
