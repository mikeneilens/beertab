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
    let tabItems:Array<TabItem>
    
    var dateString:String {
        createTS.asDateString
    }
    
    var totalValue:String {
        "£" + tabItems.map{$0.price * $0.quantity}.reduce(0){$0 + $1}.priceGBP
    }
    var totalPence:Int {
        tabItems.map{$0.price * $0.quantity}.reduce(0){$0 + $1}
    }
    func add(tabItem:TabItem)->Tab {
        Tab(name:name, createTS:createTS, pubName:pubName, branch:branch, id:id, tabItems:tabItems + [tabItem])
    }
    
    func remove(tabItem:TabItem)->Tab {
        let filteredTabItems = tabItems.filter{$0 != tabItem}
        return Tab(name:name, createTS:createTS, pubName:pubName, branch:branch, id:id, tabItems:filteredTabItems)
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
        return Tab(name:name, createTS:createTS, pubName:pubName, branch:branch, id:id, tabItems:newTabItems)
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
    
    func transactionsReport() -> String {
        let visit = (name.isEmpty) ? "" : "\(name) at "
        return "Your bill for \(visit)\(pubName): \n\n" +
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


