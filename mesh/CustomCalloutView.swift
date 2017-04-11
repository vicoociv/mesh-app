//
//  CustomCalloutView.swift
//  mesh
//
//  Created by Victor Chien on 2/19/17.
//  Copyright © 2017 Victor Chien. All rights reserved.
//

import MapKit

class CustomCalloutView: MKAnnotationView {
    var title = UILabel()
    var subtitle = UILabel()
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if (hitView != nil)
        {
            self.superview?.bringSubview(toFront: self)
        }
        return hitView
    }
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let rect = self.bounds;
        var isInside: Bool = rect.contains(point);
        if(!isInside)
        {
            for view in self.subviews
            {
                isInside = view.frame.contains(point);
                if isInside
                {
                    break;
                }
            }
        }
        return isInside;
    }
}
