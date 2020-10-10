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
        self=ListOfPubs(fromJson:json, existingList:ListOfPubs())
    }

    init (fromJson json:[String:Any], existingList:ListOfPubs) {
        var newPubHeaders = existingList.pubHeaders
        if let jsonPubs = json[K.PubListJsonName.pubs] as? [[String:Any]] {
            for jsonPub:[String:Any] in jsonPubs {
                let pubHeader=PubHeader(fromJson:jsonPub);
                newPubHeaders.append(pubHeader)
            }
        }
        self.pubHeaders = newPubHeaders
    }

}
 
// ListOfPubCreator is a factory used to make a new ListOfPubs
protocol ListOfPubsCreatorDelegate :WebServiceDelegate {
    func finishedCreating(listOfPubHeaders:ListOfPubs)
}

struct ListOfPubsCreator: WebServiceCallerType {
    
    let delegate:ListOfPubsCreatorDelegate
    let errorDelegate: WebServiceDelegate
    let serviceName = "obtain pubs"

    init (withDelegate delegate:ListOfPubsCreatorDelegate) {
        self.delegate = delegate
        self.errorDelegate = delegate
    }
    
    func createList(usingSearchString search:String, location:Location)
    {
        let urlPath = "\(K.URL.pubListURL)search=nearby&page=1&lat=51.5335538044874&lng=-0.325115913909807"
        self.requestList(usingURLString:urlPath)
    }
    
    private func requestList(usingURLString urlPath:String) {
        self.call(withDelegate: self, url: urlPath)
    }

    func finishedGetting(json:[String:Any]) {
        
        let (status, errorText)=json.errorStatus
        switch status {
        case 0:
            let listOfPubHeaders = ListOfPubs(fromJson:json)
            self.delegate.finishedCreating(listOfPubHeaders: listOfPubHeaders)
        default:
            self.failedGettingJson(error:JSONError.ConversionFailed, errorText:errorText)
        }
    }
}

extension Dictionary where Key == String {
    
    //Returns an array of values for a particular key
    //e.g. json = {"a":["xx","yy","zz"],"b":["jjj","kkk","lll"]}
    //x=getValues(json,"a","default")
    //Thus gives x a value of ["xx","yy","zz"]
    func getValues <U>(forKey:String, withDefault:U) -> [U]
    {
        guard let values = self[forKey] as? [U] else {
            
            return [U]()
        }
        return values
    }
    
    //returns a true if the value of a json element is the same as a specified value/. e.g.for json {"trueValue":"y"} if trueValue="y" then function returns true.
    func getBoolValue <U:Equatable> (forKey:String, trueIfValueIs trueValue:U)->Bool {
        guard let value = self[forKey] as? U else {
            return false
        }
        
        if (value == trueValue) {
            return true
        }
        
        return false
    }
    // returns the status and text of a Json message with format "{Message:{Status:<int>,Text:<string>},.....}"
    var errorStatus: (Int, String) {
        let message =  self[K.message]           as? [String:Any] ?? [String:Any]()
        let status  =  message[K.Message.status] as? Int          ?? -999
        let text    =  message[K.Message.text]   as? String       ?? "No message"
        
        return (status, text)
    }
}

