//
//  StationAnnotation.swift
//  iPetrol
//
//  Created by Tero Jankko on 1/19/17.
//  Copyright © 2017 Tero Jankko. All rights reserved.
//
import UIKit
import MapKit

class StationAnnotation: NSObject, MKAnnotation  {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}
