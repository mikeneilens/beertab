//
//  Int.swift
//  beertab
//
//  Created by Michael Neilens on 17/11/2020.
//

import Foundation

extension Int {
    var priceGBP:String {
        let pounds = self/100
        let decimal = self % 100 / 10
        let penny = self % 10
        return "\(pounds).\(decimal)\(penny)"
    }
}
