import UIKit

enum ParseError:Error {
    case badData(char:String?)
}

enum Currency {
    case Empty
    case HasSign(_ sign:Sign)
    case HasNoSign(_ digit:Digit)
}

enum Sign {
    case Positive(digit:Digit)
    case Negative(digit:Digit)
}

indirect enum Digit {
    case Last(value:Int)
    case HasMore(value:Int, moreDigits:Digit )
    case LastWithDecimal(value:Int, lowerDigits:LowerDigit)
}

indirect enum LowerDigit {
    case Last(value:Int)
    case HasMore(value:Int, more:LowerDigit)
}

extension Currency {
    func evaluate() -> Int {
        switch self {
            case .Empty: return 0
            case .HasSign(let sign): return sign.evaluate()
            case .HasNoSign(let digit): return digit.evaluate()
        }
    }
}
extension Sign {
    func evaluate() -> Int {
        switch self {
        case .Positive(let digit): return digit.evaluate()
        case .Negative(let digit): return -digit.evaluate()
        }
    }
}
extension Digit {
    func evaluate(_ total:Int = 0) -> Int {
        switch self {
        case .Last(let value): return (total * 10 + value) * 100
        case .HasMore(let value, let moreDigits): return moreDigits.evaluate(total * 10 + value)
        case .LastWithDecimal(let value, let lowerDigits): return lowerDigits.evaluate((total * 10 + value) * 100)
        }
    }
}
extension LowerDigit {
    func evaluate(_ total:Int, depth:Int = 0) -> Int {
        switch self {
        case .Last(let value):
            switch depth {
                case 0: return total + value * 10
                case 1: return total + value
                default: return(value < 5) ? total : total + 1
            }
        case .HasMore(let value, let more):
            switch depth {
                case 0: return more.evaluate(total +  value * 10, depth: depth + 1)
                case 1: return more.evaluate(total + value, depth: depth + 1)
                case 2: return (value < 5) ? total : total + 1
                default: return 0
            }
        }
    }
}


func createCurrency(string:String) throws -> Currency {
    let data = Array(string).map{String($0)}
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
            return Digit.LastWithDecimal(value: first, lowerDigits: try createLowerDigit(data: remainingLowerDigits))
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

let result0 = try createCurrency(string: "").evaluate()
let result1 = try createCurrency(string: "123").evaluate()
let result2 = try createCurrency(string: "+123").evaluate()
let result3 = try createCurrency(string: "-123").evaluate()
let result4 = try createCurrency(string: "-123.4").evaluate()
let result5 = try createCurrency(string: "-123.45").evaluate()
let result6 = try createCurrency(string: "-123.456").evaluate()
