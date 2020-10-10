//
//  Constants.swift
//  beertab
//
//  Created by Michael Neilens on 10/10/2020.
//

import Foundation

struct K {
    struct URL {
        static let pubListURL="https://pubcrawlapi.appspot.com/listofpubs/?"
    }
    
    struct PubListJsonName {
        static let pubs = "Pubs"
        static let name = "Name"
        static let branch = "Branch"
        static let id = "Id"
    }

    struct Message {
        static let status = "Status"
        static let text = "Text"
    }
    static let message = "Message"
    struct MapView {
        static let minSpan = 0.005
        static let maxPubsToFetch = 40
    }

}
