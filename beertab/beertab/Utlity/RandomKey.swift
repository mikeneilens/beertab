//
//  RandomKey.swift
//  beertab
//
//  Created by Michael Neilens on 08/09/2021.
//

import Foundation

func randomKey(_ size:Int = 8)->String {
    var string = ""
    for _ in 0...(size - 1) {
        string.append(Character(UnicodeScalar(Int(arc4random_uniform(26) + 65))!))
        
    }
    return string
}
