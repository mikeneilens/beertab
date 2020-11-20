//
//  UserOptionsRepository.swift
//  beertab
//
//  Created by Michael Neilens on 14/11/2020.
//

import Foundation

protocol UserOptionsArchiver {
    func set(_ option:String, value:String)
    func read(_ option:String) -> String
    func isSet(for option:String) -> Bool
}

struct UserOptionsRepository:UserOptionsArchiver {
    let key:String
    
    init(key:String = "") {
        self.key = key
    }
    
    func set(_ option:String, value:String) {
        UserDefaults.standard.set(value, forKey: (key + option) )
    }
    func read(_ option:String) -> String {
        UserDefaults.standard.object(forKey: (key + option) ) as? String ?? ""
    }
    func isSet(for option:String) -> Bool {
        if let _ = UserDefaults.standard.object(forKey: (key + option) ) {return true}
        else {return false}
    }
}
