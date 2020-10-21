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

enum Currency {
    case Empty
    case HasSign(_ sign:Sign)
    case HasNoSign(_ digit:Digit)
    
    func inPence() -> Int {
        switch self {
            case .Empty: return 0
            case .HasSign(let sign): return sign.inPence()
            case .HasNoSign(let digit): return digit.inPence()
        }
    }
}

enum Sign {
    case Positive(digit:Digit)
    case Negative(digit:Digit)

    func inPence() -> Int {
        switch self {
        case .Positive(let digit): return digit.inPence()
        case .Negative(let digit): return -digit.inPence()
        }
    }
}

indirect enum Digit {
    case Last(value:Int)
    case HasMore(value:Int, moreDigits:Digit )
    case LastWithDecimal(value:Int, lowerDigit:LowerDigit)
    
    func inPence(_ total:Int = 0) -> Int {
        switch self {
        case .Last(let value): return (total * 10 + value) * 100
        case .HasMore(let value, let moreDigits): return moreDigits.inPence(total * 10 + value)
        case .LastWithDecimal(let value, let lowerDigits): return (total * 10 + value) * 100 + lowerDigits.inPence()
        }
    }
}

indirect enum LowerDigit {
    case Last(value:Int)
    case HasMore(value:Int, more:LowerDigit)
    
    func inPence(_ total:Int = 0, depth:Int = 0) -> Int {
        switch self {
        case .Last(let value):
            switch depth {
                case 0: return total + value * 10
                case 1: return total + value
                default: return(value < 5) ? total : total + 1
            }
        case .HasMore(let value, let more):
            switch depth {
                case 0: return more.inPence(total +  value * 10, depth: depth + 1)
                case 1: return more.inPence(total + value, depth: depth + 1)
                case 2: return (value < 5) ? total : total + 1
                default: return 0
            }
        }
    }
}

func createCurrency(string:String) throws -> Currency {
    let data = Array(string).map{String($0)}.filter{$0 != " "}
    switch true {
        case data.isEmpty: return Currency.Empty
        case data[0] == "+": return Currency.HasSign(Sign.Positive(digit:try createDigit(data: Array(data.dropFirst())) ) )
        case data[0] == "-": return Currency.HasSign(Sign.Negative(digit:try createDigit(data: Array(data.dropFirst())) ) )
        default: return Currency.HasNoSign( try createDigit(data: data))
    }
}

func createDigit(data:Array<String>) throws -> Digit {
    guard let firstData = data.first,  let first = Int(firstData)  else {throw ParseError.badData(char:data.first) }
    if data.count > 1 {
        if data[1] != "."  {
            let remainingDigits = Array(data.dropFirst())
            return Digit.HasMore(value: first, moreDigits:try createDigit(data:remainingDigits))
        } else {
            let remainingLowerDigits = Array(data.dropFirst(2))
            return Digit.LastWithDecimal(value: first, lowerDigit: try createLowerDigit(data: remainingLowerDigits))
        }
    } else {
        return Digit.Last(value: first)
    }
}

func createLowerDigit(data:Array<String>) throws -> LowerDigit {
    guard let firstData = data.first,  let first = Int(firstData)  else {throw ParseError.badData(char:data.first) }
    if data.count == 1 {
        return LowerDigit.Last(value: first)
    } else {
        let remainingLowerDigits = Array(data.dropFirst())
        return LowerDigit.HasMore(value: first, more: try createLowerDigit(data: remainingLowerDigits))
    }
}

func isValidCurrency(string:String) -> Bool {
    do { _ = try createCurrency(string:string)
        return true
    } catch {
        return false
    }
}
