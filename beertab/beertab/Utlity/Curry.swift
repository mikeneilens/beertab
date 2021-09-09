//
//  Curry.swift
//  beertab
//
//  Created by Michael Neilens on 17/11/2020.
//

import Foundation

//Created this currying function as they've removed it from Swift3 https://github.com/apple/swift-evolution/blob/master/proposals/0002-remove-currying.md

precedencegroup CurryPrecedence {
    associativity: left
    higherThan: MultiplicationPrecedence
}
infix operator <<== :CurryPrecedence
//1 param
func <<==<A,Z>(_ f: @escaping (A) -> (Z), _ p:A) -> () -> (Z)  {
    { f(p) }
}
//2 param
func <<==<A,B,Z>(_ f: @escaping (A, B) -> (Z), _ p:B) -> (A) -> (Z)  {
    { (A) in f(A,p) }
}
//3 param
func <<==<A,B,C,Z>(_ f: @escaping (A, B, C) -> (Z), _ p:C) -> (A, B) -> (Z)  {
    { (A, B) in f(A,B,p) }
}
//4 param
func <<==<A,B,C,D,Z>(_ f: @escaping (A, B, C, D) -> (Z), _ p:D) -> (A, B, C) -> (Z)  {
    { (A, B, C) in f(A,B,C,p) }
}
//5 param
func <<==<A,B,C,D,E,Z>(_ f: @escaping (A, B, C, D ,E) -> (Z), _ p:E) -> (A, B, C, D) -> (Z)  {
    { (A, B, C, D) in f(A,B,C,D,p) }
}

