//
//  ReceiptItem.swift
//  beertab
//
//  Created by Michael Neilens on 20/11/2020.
//

import Foundation

struct ReceiptItem:CustomStringConvertible{
    var description: String {return "\(createTS.asTimeString) \(brewer) \(name) \(size) \(sign)£\(price) "}
    let brewer:String, name:String, size:String, price:String, createTS:Date, sign:String
    init(_ tabItem:TabItem,_ transaction:Transaction) {
        brewer = tabItem.brewer; name = tabItem.name; size = tabItem.size; price = tabItem.priceGBP; createTS = transaction.createTS
        sign = "\( transaction.transactionType == .add ? "+" : "-")"
    }
    init(_ brewer:String, _ name:String, _ size:String, _ price:String, _ createTS:Date, _ sign:String) {
        self.brewer = brewer
        self.name = name
        self.size = size
        self.price = price
        self.createTS = createTS
        self.sign = sign
    }
}
extension Array where Element == ReceiptItem {
    func sortbyCreateTS()-> Array<ReceiptItem> { self.sorted{$0.createTS < $1.createTS}}
}
