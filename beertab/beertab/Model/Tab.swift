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
        return createTS.asDateString
    }
    
    var totalValue:String {
        return "£" + tabItems.map{$0.price * $0.quantity}.reduce(0){$0 + $1}.priceGBP
    }
    var totalPence:Int {
        return tabItems.map{$0.price * $0.quantity}.reduce(0){$0 + $1}
    }
    func add(tabItem:TabItem)->Tab {
        return Tab(name:name, createTS:createTS, pubName:pubName, branch:branch, id:id, tabItems:tabItems + [tabItem])
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
}

struct ReceiptItem:CustomStringConvertible{
    var description: String {return "\(createTS.asTimeString) \(brewer) \(name) \(size) \(sign)£\(price) "}
    let brewer:String, name:String, size:String, price:String, createTS:Date, sign:String
    init(_ tabItem:TabItem,_ transaction:Transaction) {
        brewer = tabItem.brewer; name = tabItem.name; size = tabItem.size; price = tabItem.priceGBP; createTS = transaction.createTS
        sign = "\( transaction.transactionType == .add ? "+" : "-")"
    }
    init(_ brewer:String, _ name:String, _ size:String, _ price:String, _ createTS:Date, _ sign:String) {
        self.brewer = brewer;self.name = name; self.size = size; self.price = price; self.createTS = createTS; self.sign = sign
    }
}
extension Array where Element == ReceiptItem {
    func sortbyCreateTS()-> Array<ReceiptItem> { self.sorted{$0.createTS < $1.createTS}}
}

extension Date {
    var asDateString:String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_GB")
        return dateFormatter.string(from: self)
    }
    var asTimeString:String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "en_GB")
        return dateFormatter.string(from: self)
    }
    var asDateAndTimeString:String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "en_GB")
        return dateFormatter.string(from: self)
    }
}
