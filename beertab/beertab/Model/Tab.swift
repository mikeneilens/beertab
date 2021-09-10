//
//  tab.swift
//  beertab
//
//  Created by Michael Neilens on 04/10/2020.
//

import Foundation

struct Tab:Codable, Equatable {
    static func == (lhs: Tab, rhs: Tab) -> Bool {
        return lhs.name == rhs.name && lhs.pubName == rhs.pubName && lhs.createTS == rhs.createTS
    }
    
    let name:String
    let createTS:Date
    let pubName:String
    let branch:String
    let id:String
    let tabId:String?
    let tabItems:Array<TabItem>
    
    var dateString:String {
        createTS.asDateString
    }
    
    var totalValue:String {
        "£" + totalPence.priceGBP
    }
    var totalPence:Int {
        tabItems.map{$0.price * $0.quantity}.reduce(0){$0 + $1}
    }
    
    init(name:String, createTS:Date, pubName:String, branch:String, id:String) {
        self.name = name
        self.createTS = createTS
        self.pubName = pubName
        self.branch = branch
        self.id = id
        self.tabId = randomKey()
        self.tabItems = []
    }
    
    func replaceItemsWith(_ tabItems:Array<TabItem>) -> Tab {
        return Tab(name:self.name, createTS: self.createTS, pubName: self.pubName, branch: self.branch, id:self.id, tabId: self.tabId, tabItems: tabItems)
    }
    
    private init(name:String, createTS:Date, pubName:String, branch:String, id:String, tabId:String?, tabItems:Array<TabItem>) {
        self.name = name
        self.createTS = createTS
        self.pubName = pubName
        self.branch = branch
        self.id = id
        self.tabId = tabId
        self.tabItems = tabItems
    }
    
    func add(tabItem:TabItem)->Tab {
        replaceItemsWith(tabItems + [tabItem])
    }
    
    func remove(tabItem:TabItem)->Tab {
        let filteredTabItems = tabItems.filter{$0 != tabItem}
        return replaceItemsWith(filteredTabItems)
    }
    
    func replace(position:Int, newTabItem:TabItem ) -> Tab {
        var  newTabItems:Array<TabItem> = []
        for (index,tabItem) in tabItems.enumerated() {
            if index == position {
                let replacementTabItem = TabItem(brewer: newTabItem.brewer, name: newTabItem.name, size: newTabItem.size, price: newTabItem.price, transactions:tabItem.transactions)
                newTabItems.append(replacementTabItem)
            } else {
                newTabItems.append(tabItem)
            }
        }
        return replaceItemsWith(newTabItems)
    }
    
    func addTransaction(brewer:String, name:String, size:String) -> Tab {
        let tabItem = TabItem(brewer: brewer, name: name, size: size, price: 0)
        let newTabItems:Array<TabItem> = tabItems.map{if $0 == tabItem {return $0.addTransaction()} else {return $0}}
        return replaceItemsWith(newTabItems)
    }
    func removeTransaction(brewer:String, name:String, size:String) -> Tab {
        let tabItem = TabItem(brewer: brewer, name: name, size: size, price: 0)
        let newTabItems:Array<TabItem> = tabItems.map{if $0 == tabItem {return $0.removeTransaction()} else {return $0}}
        return replaceItemsWith(newTabItems)
    }
    
    func transactionsReport(history:History) -> String {
        let visit = (name.isEmpty) ? "" : "\(name) at "
        let billOwner = history.contains(tab:self) ? "Your":"Other"
        
        return "\(billOwner) bill for \(visit)\(pubName): \n\n" +
                tabItems.flatMap{ tabItem in tabItem.transactions.map{transaction in ReceiptItem(tabItem, transaction) } }
                        .sortbyCreateTS()
                        .map{"\($0)"}
                        .joined(separator: "\n") +
                "\n \nTotal: \(totalValue)"
    }
    
    func encode() -> String? {
        let encoder = JSONEncoder()
        do {let encoded = try encoder.encode(self)
            return String(data: encoded, encoding: .utf8)
        } catch {
            print("couldn't encode tab \(self)")
            return nil
        }
    }

}


