//
//  TabItem.swift
//  beertab
//
//  Created by Michael Neilens on 04/10/2020.
//

import Foundation

struct TabItem:Codable {
    let brewer:String
    let name:String
    let size:String
    let price:Int
    let transactions:Array<Transaction>
    
    var quantity:Int  {
        transactions.filter{$0.transactionType == TransactionType.add}.count - transactions.filter{$0.transactionType == TransactionType.remove}.count
    }
    
    var priceGBP:String {
        price.priceGBP
    }
    
    init(brewer:String, name:String, size:String, price:Int, transactions:Array<Transaction>) {
        self.brewer = brewer
        self.name = name
        self.size = size
        self.price = price
        self.transactions = transactions
    }
    init(brewer:String, name:String, size:String, price:Int) {
        self.brewer = brewer
        self.name = name
        self.size = size
        self.price = price
        self.transactions = []
    }
    
    func addTransaction() -> TabItem {
        TabItem(brewer: brewer, name: name, size: size, price: price, transactions:transactions + [Transaction(transactionType: .add)])
    }
    func removeTransaction() -> TabItem {
        TabItem(brewer: brewer, name: name, size: size, price: price, transactions:transactions + [Transaction(transactionType: .remove)])
    }
}
func == (lhs: TabItem, rhs: TabItem) -> Bool {
    lhs.brewer == rhs.brewer && lhs.name == rhs.name && lhs.size == rhs.size
    }
func != (lhs: TabItem, rhs: TabItem) -> Bool {
     !(lhs == rhs)
}

enum TransactionType:String, Codable{
    case add = "add"
    case remove = "remove"
}

struct Transaction:Codable {
    let transactionType:TransactionType
    var createTS = Date()
}

extension Int {
    var priceGBP:String {
        let pounds = self/100
        let decimal = self % 100 / 10
        let penny = self % 10
        return "\(pounds).\(decimal)\(penny)"
    }
}
