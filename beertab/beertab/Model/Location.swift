//
//  Location.swift
//  beertab
//
//  Created by Michael Neilens on 10/10/2020.
//

import Foundation
import CoreLocation

struct UKCoOrdinates {
    static let minLat = 49.8
    static let maxLat = 60.9
    static let minLng = -10.7
    static let maxLng = 1.9
}

enum LocationStatus:Equatable {
    case NotSet
    case Set(location:Location)
}

struct Location:Equatable {
    let lng:Double
    let lat:Double
    var isEmpty:Bool {
        if lng==0.0 && lat==0.0 {
            return true
        } else {
            return false
        }
    }
    var isOutsideUK:Bool {
        (self.lat < UKCoOrdinates.minLat ) || (self.lat > UKCoOrdinates.maxLat) || (self.lng < UKCoOrdinates.minLng) || (self.lng > UKCoOrdinates.maxLng)
    }
    init(lng:Double, lat:Double) {
        self.lng = lng
        self.lat = lat
    }
    init(fromCoordinate locValue:CLLocationCoordinate2D) {
        self.lat = locValue.latitude
        self.lng = locValue.longitude
    }
    
    static func == (lhs:Location, rhs:Location) -> Bool {
        (lhs.lat == rhs.lat) && (lhs.lng == rhs.lng)
    }
}
