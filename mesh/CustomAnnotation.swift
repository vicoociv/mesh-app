//
//  CustomAnnotation.swift
//  mesh
//
//  Created by Victor Chien on 2/4/17.
//  Copyright © 2017 Victor Chien. All rights reserved.
//

import UIKit
import MapKit

class CustomAnnotation : NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
    
    func annotationView() -> MKAnnotationView {
        let view = MKAnnotationView(annotation: self, reuseIdentifier: "CustomAnnotation")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isEnabled = true
        view.canShowCallout = true
        view.rightCalloutAccessoryView = UIButton(type: UIButtonType.custom)
        view.centerOffset = CGPoint(x: 0, y: -32)
        view.backgroundColor = UIColor.green
        return view
    }
}
