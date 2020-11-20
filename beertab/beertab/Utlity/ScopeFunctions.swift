//
//  ScopeFunctions.swift
//  beertab
//
//  Created by Michael Neilens on 31/10/2020.
//

import Foundation

protocol ScopeFunc {}
extension ScopeFunc {
    @inline(__always) func apply(block: (Self) -> ()) -> Self {
        block(self)
        return self
    }
    @inline(__always) func with<R>(block: (Self) -> R) -> R {
        block(self)
    }
}

extension NSObject: ScopeFunc {}
