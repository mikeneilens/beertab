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
        allTabs.sorted{$0.createTS > $1.createTS}
    }
    
    var tabsByDate:Array<(date:String, tabs:Array<Tab>)> {
        let dates = tabs.map{$0.dateString}.unique{$0 == $1}
        return dates.map{date in return (date, tabs.filter{$0.dateString == date})}
    }
    
    func add(tab:Tab) -> History {
        History(allTabs: allTabs + [tab])
    }
    func remove(tab:Tab)->History {
        let filteredTabs = allTabs.filter{$0 != tab}
        return History(allTabs: filteredTabs)
    }
    func update(tab:Tab) -> History {
        let newTabs:Array<Tab> =  allTabs.map{if $0.createTS == tab.createTS {return tab} else {return $0}}
        return History(allTabs:newTabs)
    }
}

