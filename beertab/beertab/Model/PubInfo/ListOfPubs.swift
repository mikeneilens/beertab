//
//  ListOfPubs.swift
//  beertab
//
//  Created by Michael Neilens on 10/10/2020.
//

import Foundation

struct ListOfPubs {
    let pubHeaders:[PubHeader]

    init () {
        self.pubHeaders = [PubHeader]()
    }
    
    init (fromJson json:[String:Any]) {
        if let jsonPubs = json[K.PubListJsonName.pubs] as? [[String:Any]] {
            self.pubHeaders = jsonPubs.map{ jsonPub in return PubHeader(fromJson:jsonPub) }
        } else {
            self.pubHeaders = [PubHeader]()
        }
    }
}
 

