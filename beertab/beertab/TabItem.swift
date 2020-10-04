//
//  TabItem.swift
//  beertab
//
//  Created by Michael Neilens on 04/10/2020.
//

import Foundation

struct TabItem {
    let brewer:String
    let name:String
    let size:String
    let price:Int
    let transactions:Array<Transaction>
    
    var quantity:Int  {return transactions.filter{$0.transactionType == TransactionType.add}.count - transactions.filter{$0.transactionType == TransactionType.remove}.count}
    
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
        return TabItem(brewer: brewer, name: name, size: size, price: price, transactions:transactions + [Transaction(transactionType: .add)])
    }
    func removeTransaction() -> TabItem {
        return TabItem(brewer: brewer, name: name, size: size, price: price, transactions:transactions + [Transaction(transactionType: .remove)])
    }
}
func == (lhs: TabItem, rhs: TabItem) -> Bool {
        return
            lhs.brewer == rhs.brewer &&
            lhs.name == rhs.name &&
            lhs.size == rhs.size
    }
func != (lhs: TabItem, rhs: TabItem) -> Bool {
    return !(lhs == rhs)
}

enum TransactionType{
    case add
    case remove
}

struct Transaction {
    let transactionType:TransactionType
    let createTS = Date()
}
