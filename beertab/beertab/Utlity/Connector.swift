//
//  Connector.swift
//  beertab
//
//  Created by Michael Neilens on 18/11/2020.
//

import Foundation

protocol HTTPConnector {
    func send(request:URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?)->())
}

struct Connector:HTTPConnector {
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    func send(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) {
        session.dataTask(with: request, completionHandler: completionHandler).resume()
    }
}
