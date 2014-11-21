//
//  LocationStore.swift
//  GeoCode3
//
//  Created by Tim Chagnon on 11/20/14.
//  Copyright (c) 2014 Michael Droz. All rights reserved.
//

import Foundation
import CoreLocation

@objc
public class LocationStore: NSObject {

    let rootRef:Firebase
    let geoRef: GeoFire

    override init() {
        rootRef = Firebase(url:"https://burning-fire-6675.firebaseio.com/locations")
        geoRef = GeoFire(firebaseRef: rootRef)
        super.init()
    }

    func addLocation(location: CLLocation, forKey:String) {
        geoRef.setLocation(location, forKey: forKey)
    }

    func queryNearbyLocations(location: CLLocation, radius: Double, withBlock:(key: String!, location: CLLocation!)->()) {
        let query = geoRef.queryAtLocation(location, withRadius: radius)
        query.observeEventType(GFEventTypeKeyEntered, withBlock: withBlock)
    }
}