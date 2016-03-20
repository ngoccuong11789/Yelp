//
//  BootcampAnnotation.swift
//  Yelp
//
//  Created by mac on 3/19/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import Foundation
import MapKit

class BootcampAnnotation: NSObject, MKAnnotation {
    var coordinate = CLLocationCoordinate2D()
    
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        
    }
}
