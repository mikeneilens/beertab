//
//  Pub.swift
//  beertab
//
//  Created by Michael Neilens on 10/10/2020.
//

import Foundation

struct PubHeader {
    let name:String
    let branch:String
    let id:String
    
    init() { self = PubHeader(fromJson:[:])}
    
    init (fromJson json:[String:Any]) {
        self.name         = json[K.PubListJsonName.name]  as? String ?? ""
        self.branch         = json[K.PubListJsonName.branch]     as? String ?? ""
        self.id     = json[K.PubListJsonName.id] as? String ?? ""
    }
}


