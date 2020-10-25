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
        var result:Array<(date:String, tabs:Array<Tab>)> = []
        for tab in tabs {
            if result.isEmpty {
                result.append((tab.dateString, [tab] ) )
            } else {
                result = addTabToResult(tab: tab, result: result)
            }
        }
        return result
    }
    
    func addTabToResult(tab:Tab, result:Array<(date:String, tabs:Array<Tab>)> ) -> Array<(date:String, tabs:Array<Tab>)> {
        var newResult = result
        if result.last?.date == tab.dateString {
            newResult[result.count - 1] = (tab.dateString, result[result.count - 1].tabs + [tab])
        } else {
            newResult.append((tab.dateString, [tab] ) )
        }
        return newResult
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
