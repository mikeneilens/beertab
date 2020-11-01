//
//  Array.swift
//  beertab
//
//  Created by Michael Neilens on 01/11/2020.
//

import Foundation

extension Array {
    func prefixNoMoreThan(_ quantity:Int) -> ArraySlice<Element> {
        let maxQuantity = (quantity < count ? quantity : count )
        return prefix(upTo:maxQuantity)
    }
}

extension Array { 
     func unique(selector:(Element,Element)->Bool) -> Array<Element> {
        return reduce(Array<Element>()){
            if let last = $0.last {
                return selector(last,$1) ? $0 : $0 + [$1]
            } else {
                return [$1]
            }
        }
    }
}
