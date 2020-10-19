//
//  History.swift
//  beertab
//
//  Created by Michael Neilens on 04/10/2020.
//

import Foundation

struct History:Codable {
    
    let allTabs:Array<Tab>
    
    var tabs:Array<Tab> {
        return allTabs.sorted{$0.createTS > $1.createTS}
    }
    
    func add(tab:Tab) -> History {
        return History(allTabs: allTabs + [tab])
    }
    func remove(tab:Tab)->History {
        let filteredTabs = allTabs.filter{$0 != tab}
        return History(allTabs: filteredTabs)
    }
    func update(tab:Tab) -> History {
        let newTabs:Array<Tab> =  allTabs.map{if $0.createTS == tab.createTS {return tab} else {return $0}}
        return History(allTabs:newTabs)
    }
    func save(key:String, errorResponse: (History,String) -> ()) {
        HistoryArchive(key:key).write(history: self, errorResponse: errorResponse)
    }
}