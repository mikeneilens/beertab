//
//  tab.swift
//  beertab
//
//  Created by Michael Neilens on 04/10/2020.
//

import Foundation

struct Tab:Codable, Equatable {
    static func == (lhs: Tab, rhs: Tab) -> Bool {
        return lhs.name == rhs.name && lhs.pubName == rhs.pubName && lhs.createTS == lhs.createTS
    }
    
    let name:String
    let createTS:Date
    let pubName:String
    let branch:String
    let id:String
    let tabItems:Array<TabItem>
    
    var dateString:String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_GB")        
        return dateFormatter.string(from: createTS)
    }
    
    var totalValue:String {
        return tabItems.map{$0.price * $0.quantity}.reduce(0){$0 + $1}.priceGBP
    }
    func add(tabItem:TabItem)->Tab {
        return Tab(name:name, createTS:createTS, pubName:pubName, branch:branch, id:id, tabItems:tabItems + [tabItem])
    }
    
    func remove(tabItem:TabItem)->Tab {
        let filteredTabItems = tabItems.filter{$0 != tabItem}
        return Tab(name:name, createTS:createTS, pubName:pubName, branch:branch, id:id, tabItems:filteredTabItems)
    }
    
    func addTransaction(brewer:String, name:String, size:String) -> Tab {
        let tabItem = TabItem(brewer: brewer, name: name, size: size, price: 0)
        let newTabItems:Array<TabItem> = tabItems.map{if $0 == tabItem {return $0.addTransaction()} else {return $0}}
        return Tab(name:self.name, createTS:self.createTS, pubName:self.pubName, branch:branch, id:id, tabItems:newTabItems)
    }
    func removeTransaction(brewer:String, name:String, size:String) -> Tab {
        let tabItem = TabItem(brewer: brewer, name: name, size: size, price: 0)
        let newTabItems:Array<TabItem> = tabItems.map{if $0 == tabItem {return $0.removeTransaction()} else {return $0}}
        return Tab(name:self.name, createTS:self.createTS, pubName:self.pubName, branch:branch, id:id, tabItems:newTabItems)
    }
    
}


