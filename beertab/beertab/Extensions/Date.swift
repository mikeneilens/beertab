//
//  Date.swift
//  beertab
//
//  Created by Michael Neilens on 20/11/2020.
//

import Foundation

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
