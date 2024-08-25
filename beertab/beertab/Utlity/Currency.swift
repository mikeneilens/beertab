//
//  Currency.swift
//  beertab
//
//  Created by Michael Neilens on 19/10/2020.
//

import Foundation

enum ParseError:Error {
    case badData(char:String?)
}
// Currency can be empty (and therefore value zero) or start with a Sign or start with no sign and therefore starts with a Digit.
// A Sign is either Positive or Negative and is followed by a Digit.
// A Digit is either the last Digit (has a value but nothing else follows it) or has a value with another Digit following it or has a value with a decimal following it. The decimal is followed by a LowerDigit.
// A LowerDigit is either the last LowerDigit (has a value but nothing else follows it) or has a value with another LowerDigit after it.

struct Currency {
    let inPence:Int
    
    init(_ string:String) {
        let stringWithPence = Currency.addPence(string)
        let (poundsString, penniesString) = Currency.poundsAndPence(stringWithPence)
        let pounds = Int(poundsString) ?? 0
        let pennies = Int( Currency.decimalPence(penniesString)) ?? 0
        inPence = if pounds >= 0 {
            pounds * 100 + pennies
        } else {
            pounds * 100 - pennies
        }
    }
    static func addPence(_ string:String) -> String {
        if string.contains(".") {
            string
        } else {
            string + ".00"
        }
    }
    static func poundsAndPence(_ string:String)-> (String, String) {
        (string.components(separatedBy: ".")[0],string.components(separatedBy: ".")[1])
    }
    static func decimalPence(_ pence:String) -> String {
        switch pence.count {
        case 0: pence + "00"
        case 1: pence + "0"
        case 2: pence
        default: String( pence.prefix(2))
        }
    }
}
