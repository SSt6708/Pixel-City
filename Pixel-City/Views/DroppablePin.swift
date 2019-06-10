//
//  DroppablePin.swift
//  Pixel-City
//
//  Created by Steven Liu on 2019/6/9.
//  Copyright © 2019 Steven Liu. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class DroppablePin: NSObject, MKAnnotation {
    
    dynamic var coordinate: CLLocationCoordinate2D
    var identifier:String
    
    init(coordinate: CLLocationCoordinate2D, identifier: String){
        self.coordinate = coordinate
        self.identifier = identifier
        super.init()
    }
    
}
