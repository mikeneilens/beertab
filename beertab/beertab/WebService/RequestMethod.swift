//
//  RequestMethod.swift
//  beertab
//
//  Created by Michael Neilens on 10/10/2020.
//

import Foundation

public enum RequestMethod {
    case Get
    case Post
    case Put
    case Patch
    case Delete
    
    var asString:String {
        switch self {
        case .Get: return "GET"
        case .Post: return "POST"
        case .Put: return "PUT"
        case .Patch: return "PATCH"
        case .Delete: return "DELETE"
        }
    }
}
