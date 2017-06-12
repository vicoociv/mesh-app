//
//  PaddedLabel.swift
//  mesh
//
//  Created by Victor Chien on 4/27/17.
//  Copyright © 2017 Victor Chien. All rights reserved.
//

import Foundation
import UIKit


class PaddedLabel: UILabel {

    let padding = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, padding))
    }
    
    override var intrinsicContentSize : CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + padding.left + padding.right
        let heigth = superContentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }
}
