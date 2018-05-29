//
//  Pin.swift
//  LocApp
//
//  Created by Musa Lheureux on 26/05/2018.
//  Copyright © 2018 LocApp. All rights reserved.
//

import UIKit
import MapKit
import Contacts

class Pin: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    
    var title: String?
    var subtitle: String?
    
    init(_ centerCoordinate: CLLocationCoordinate2D) {
        self.coordinate = centerCoordinate
        
        super.init()
    }
    
    // Annotation right callout accessory opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }

}
