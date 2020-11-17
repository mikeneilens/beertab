//
//  Curry.swift
//  beertab
//
//  Created by Michael Neilens on 17/11/2020.
//

import Foundation
func curry<A,B,C,D,E>(_ f: @escaping (A, B, C, D) -> (E), _ p:D) -> (A, B, C) -> (E)  {
    { (A, B, C) in f(A,B,C,p) }
}
