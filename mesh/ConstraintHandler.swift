//
//  constraintHandler.swift
//  fishBowl
//
//  Created by Victor Chien on 5/13/17.
//  Copyright © 2017 Victor Chien. All rights reserved.
//

import Foundation
import UIKit

class ConstraintHandler {
    private var constraintsDict: [String: [String: NSLayoutConstraint]] = [:]
    private static let screenHeight = UIScreen.main.bounds.height
    
    func addConstraint(object: String, type: String, constraint: NSLayoutConstraint) {
        
        if constraintsDict[object] == nil {
            constraintsDict[object] = [type: constraint]
        } else {
            constraintsDict[object]?[type] = constraint
        }
    }
    
    func getConstraint(object: String, type: String) -> NSLayoutConstraint {
        return constraintsDict[object]![type]!
    }
    
    static func getPercentage(_ amount: CGFloat) -> CGFloat {
        let constant: CGFloat = 667.0
        return amount/constant * screenHeight
    }
}
