//
//  Tag.swift
//  mesh
//
//  Created by Victor Chien on 2/14/17.
//  Copyright © 2017 Victor Chien. All rights reserved.
//

import MapKit

//make another object to wrap over this one so can store even more information
class Tag: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    var intID: Int

    init(id: Int) {
        intID = id
        title = ""
        info = ""
        coordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    }
    
    init(id: Int, title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.intID = id
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
    
    func getID() -> Int {
        return intID
    }
    
    func getTitle() -> String {
        return title!
    }
    
    func getDescription() -> String {
        return info
    }
    
    func getLatitude() -> Double {
        return coordinate.latitude
    }
    
    func getLongitude() -> Double {
        return coordinate.longitude
    }
    
    func checkEquals(tag: Tag) -> Bool {
        if intID == tag.getID() && title == tag.getTitle() && coordinate.latitude == tag.getLatitude() && coordinate.longitude == tag.getLongitude() && info == tag.getDescription() {
            return true
        } else {
            return false
        }
    }
}
