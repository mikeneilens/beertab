//
//  URLRequest.swift
//  beertab
//
//  Created by Michael Neilens on 17/11/2020.
//

import Foundation

enum RequestMethod {
    case Get
    case Post
    case Put
    case Patch
    case Delete
    
    var asString:String {
        switch (self) {
        case .Get:  return "Get"
        case .Post: return "Post"
        case .Put: return "Put"
        case .Patch: return "Patch"
        case .Delete: return "Delete"
        }
    }
}

extension URLRequest {
    init(url:URL, requestMethod:RequestMethod, httpHeaders:[String:String]?, httpBody:Data?) {
        self = URLRequest(url: url)
        self.httpMethod = requestMethod.asString
        self.allHTTPHeaderFields=httpHeaders
        self.httpBody = httpBody
    }
}
