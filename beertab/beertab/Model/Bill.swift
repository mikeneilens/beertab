//
//  Bill.swift
//  beertab
//
//  Created by Michael Neilens on 08/09/2021.
//

import Foundation

struct Bill:Equatable, Codable {
    let billId:String
    let tabs:Array<Tab>
    
    init(tab:Tab) {
        billId = randomKey(4)
        tabs = [tab]
    }
    init(fromJson json:[String : Any]) {
        self.billId = json["billId"] as? String ?? ""
        self.tabs = []
    }
    
    var totalValue:String {
        "£" + totalPence.priceGBP
    }
    
    var totalPence:Int {
        tabs.map{$0.totalPence}.reduce(0){$0 + $1}
    }
    
    func report(history:History) -> String {
        return tabs.map{$0.transactionsReport(history: history)}.joined(separator: "\n--------------------------------\n\n") + "\n==============================\nTotal Bill: " + totalValue
    }
}
