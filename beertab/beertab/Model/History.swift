//
//  History.swift
//  beertab
//
//  Created by Michael Neilens on 04/10/2020.
//

import Foundation

struct History:Codable {
    
    let allTabs:Array<PubTab>
    
    lazy var tabs:Array<PubTab> = {
        allTabs.sorted{$0.createTS > $1.createTS}
    }()
    
    lazy var tabsByDate:Array<(date:String, tabs:Array<PubTab>)> = {
        let dates = tabs.map{$0.dateString}.unique{$0 == $1}
        return dates.map{date in return (date, tabs.filter{$0.dateString == date})}
    }()
    
    func add(tab:PubTab) -> History {
        History(allTabs: allTabs + [tab])
    }
    func remove(tab:PubTab)->History {
        let filteredTabs = allTabs.filter{$0 != tab}
        return History(allTabs: filteredTabs)
    }
    func update(tab:PubTab) -> History {
        let newTabs:Array<PubTab> =  allTabs.map{if $0.createTS == tab.createTS {return tab} else {return $0}}
        return History(allTabs:newTabs)
    }
    func contains(tab:PubTab) -> Bool{
        allTabs.contains{historyTab in historyTab.tabId == tab.tabId}
    }
}

