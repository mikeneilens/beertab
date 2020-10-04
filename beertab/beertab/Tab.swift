//
//  tab.swift
//  beertab
//
//  Created by Michael Neilens on 04/10/2020.
//

import Foundation

struct Tab {
    let name:String
    let createTS:Date
    let pubName:String
    let postcode:String
    let tabItems:Array<TabItem>
    
    func add(tabItem:TabItem)->Tab {
        return Tab(name:name, createTS:createTS, pubName:pubName, postcode:postcode, tabItems:tabItems + [tabItem])
    }
    
    func remove(tabItem:TabItem)->Tab {
        let filteredTabItems = tabItems.filter{$0 != tabItem}
        return Tab(name:name, createTS:createTS, pubName:pubName, postcode:postcode, tabItems:filteredTabItems)
    }
    
    func addTransaction(brewer:String, name:String, size:String) -> Tab {
        let tabItem = TabItem(brewer: brewer, name: name, size: size, price: 0)
        let newTabItems:Array<TabItem> = tabItems.map{if $0 == tabItem {return $0.addTransaction()} else {return $0}}
        return Tab(name:name, createTS:createTS, pubName:pubName, postcode:postcode, tabItems:newTabItems)
    }
    func removeTransaction(brewer:String, name:String, size:String) -> Tab {
        let tabItem = TabItem(brewer: brewer, name: name, size: size, price: 0)
        let newTabItems:Array<TabItem> = tabItems.map{if $0 == tabItem {return $0.removeTransaction()} else {return $0}}
        return Tab(name:name, createTS:createTS, pubName:pubName, postcode:postcode, tabItems:newTabItems)
    }
    
}


