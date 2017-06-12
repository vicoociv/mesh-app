//
//  Constraints.swift
//  mesh
//
//  Created by Victor Chien on 4/23/17.
//  Copyright © 2017 Victor Chien. All rights reserved.
//

import UIKit

extension UIView {
    
    private func constrainTop(to: UIView, constant: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: to, attribute: NSLayoutAttribute.top, multiplier: 1, constant: constant)
    }
    
    private func constrainBottom(to: UIView,  constant: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: to, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: constant)
    }
    
    private func constrainLeft(indicator: Bool, to: UIView, constant: CGFloat) -> NSLayoutConstraint {
        if indicator {
            return NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: to, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: constant)
        } else {
            return NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.lessThanOrEqual, toItem: to, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: constant)
        }
    }
    
    private func constrainRight(indicator: Bool, to: UIView, constant: CGFloat) -> NSLayoutConstraint {
        if indicator {
            return NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.lessThanOrEqual, toItem: to, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: constant)
        } else {
            return NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: to, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: constant)
        }
    }
    
    func constrainWidth(to: UIView,  constant: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.lessThanOrEqual, toItem: to, attribute: NSLayoutAttribute.width, multiplier: 1, constant: -(constant))
    }
    
    private func constrainHeight(to: UIView,  constant: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: to, attribute: NSLayoutAttribute.height, multiplier: 1, constant: constant)
    }
    
    
    func constrainSidesView(indicator: Bool, to: UIView, top: CGFloat, bottom: CGFloat, right: CGFloat, left: CGFloat) -> [NSLayoutConstraint] {
        var tempList: [NSLayoutConstraint] = []
        
        if top != -60 {
            tempList.append(constrainTop(to: to, constant: top))
        }
        if bottom != -60 {
            tempList.append(constrainBottom(to: to, constant: -(bottom)))
        }
        if left != -60 {
            tempList.append(constrainLeft(indicator: indicator, to: to, constant: left))
        }
        if right != -60 {
            tempList.append(constrainRight(indicator: indicator, to: to, constant: -(right)))
        }
        return tempList
    }
}
