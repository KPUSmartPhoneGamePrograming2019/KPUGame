//
//  Hospital.swift
//  HospitalMap real
//
//  Created by 최지 on 02/05/2019.
//  Copyright © 2019 최지. All rights reserved.
//

import Foundation
import MapKit

import Contacts

class Hospital: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D){
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }

    var subtitle: String?{
        return locationName
    }

    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStateKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}
