//
//  MockConnector.swift
//  beertabTests
//
//  Created by Michael Neilens on 18/11/2020.
//

import Foundation
@testable import beertab
class MockConnector:HTTPConnector {
    let data:Data?
    let response:URLResponse?
    let error:Error?
    var noOfTimesSendRequested = 0
    var urlRequest = URLRequest(url:URL(string:"https://abc.com")!)
    init (data:Data?, response:URLResponse?, error:Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
    func send(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) {
        noOfTimesSendRequested += 1
        urlRequest = request
        completionHandler(data,response,error)
    }
}
