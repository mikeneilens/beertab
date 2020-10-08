//
//  UId.swift
//  beertab
//
//  Created by Michael Neilens on 06/10/2020.
//

import Foundation

struct UId {
    var text=""
    
    mutating func refreshUId() {
        let defaults: UserDefaults = UserDefaults.standard
        if let uId = defaults.string(forKey: "uId") {
            self.text = uId
        } else {
            var string = ""
            for _ in 0...15 {
                string.append(Character(UnicodeScalar(Int(arc4random_uniform(26) + 65))!))
                
            }
            self.text=string
            defaults.set(self.text, forKey: "uId")
        }
        
    }
    
}


