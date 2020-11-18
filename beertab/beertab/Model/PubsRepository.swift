//
//  PubsRepository.swift
//  beertab
//
//  Created by Michael Neilens on 17/11/2020.
//

import Foundation

protocol PubsArchive {
    func readPubsNearBy(location:Location, onCompletion completion:@escaping (ListOfPubs) -> ())
}

struct PubsRepository:PubsArchive {
    var connector:HTTPConnector = Connector()
    func readPubsNearBy(location:Location, onCompletion completion:@escaping (ListOfPubs) -> ()) {
        guard let url = URL(string:"\(K.URL.pubListURL)search=nearby&page=1&lat=\(location.lat)&lng=\(location.lng)") else { return }
        let urlRequest = URLRequest(url: url, requestMethod: .Get, httpHeaders: nil, httpBody: nil)
        connector.send(request: urlRequest, completionHandler: readCompletion <<== completion)
    }
    
    func readCompletion(data:Data?, response:URLResponse?, error:Error?, completion:@escaping (ListOfPubs) -> ()) {
        if let error = error {print("Invalid response \(error)");return}
        guard let data = data else {print("No Data");return}
        let listOfPubs = decode(data: data)
        DispatchQueue.main.async {
            completion(listOfPubs)
        }
    }
    
    func decode(data:Data) -> ListOfPubs {
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                if let jsonDict = json as? [String:Any] {
                    return ListOfPubs(fromJson:jsonDict)
                } else {
                    return ListOfPubs()
                }
            } else { return ListOfPubs()}
        } catch { return ListOfPubs() }
    }
}
