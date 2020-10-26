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
    
    func tabsByDate() -> Array<(date:String, tabs:Array<Tab>)> {
        let dates = tabs.map{$0.dateString}.unique{$0 == $1}
        return dates.map{date in return (date, tabs.filter{$0.dateString == date})}
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

extension Array {
    func unique(selector:(Element,Element)->Bool) -> Array<Element> {
        return reduce(Array<Element>()){
            if let last = $0.last {
                return selector(last,$1) ? $0 : $0 + [$1]
            } else {
                return [$1]
            }
        }
    }
}
