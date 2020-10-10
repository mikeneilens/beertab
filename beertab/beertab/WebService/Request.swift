//
//  Request.swift
//  beertab
//
//  Created by Michael Neilens on 10/10/2020.
//

import Foundation

public struct Request {
    let urlString:String
    let requestMethod:RequestMethod
    let httpHeaders:[String:String]?
    let httpBody:Data?
    
    public init(urlString:String, requestMethod:RequestMethod = .Get, httpHeaders:[String:String]?=nil, httpBody:Data?=nil) {
        self.urlString = urlString
        self.requestMethod = requestMethod
        self.httpHeaders = httpHeaders
        self.httpBody = httpBody
    }
    public init(urlString:String, httpHeaders:[String:String]?=nil, httpBody:Data?=nil) {
        self = Request(urlString: urlString, requestMethod: RequestMethod.Get, httpHeaders: httpHeaders, httpBody: httpBody)
    }
}
