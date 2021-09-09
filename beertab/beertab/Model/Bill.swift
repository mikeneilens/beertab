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
}

extension Array where Element == Bill {
    func billContaining(tab:Tab) -> Bill? {
        first(where: {bill in bill.tabs.contains(where: {tabInBill in tabInBill.tabId == tab.tabId})})
    }
}
