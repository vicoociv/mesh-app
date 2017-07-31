//
//  checkBox.swift
//  fishBowl
//
//  Created by Victor Chien on 7/18/17.
//  Copyright © 2017 Victor Chien. All rights reserved.
//

import Foundation
import UIKit

class CheckBoxImage: UIImageView {
    
    private var color = UIColor.white
    
    func setColor(color: UIColor) {
        self.color = color
    }
    
    func toggle(_ indicator: Bool) {
        if indicator {
            let image = UIImage(named: "checkBoxOn.png")
            self.image = image?.maskWithColor(color: color)
        } else {
            let image = UIImage(named: "checkBoxOff.png")
            self.image = image?.maskWithColor(color: color)
        }
    }
    
    override init(image: UIImage?) {
        super.init(image: image)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CheckBoxButton: Button {
    
    private var color = UIColor.white
    
    func setColor(color: UIColor) {
        self.color = color
    }
    
    func toggle(_ indicator: Bool) {
        if indicator {
            let image = UIImage(named: "checkBoxOn.png")
            self.setImage(image?.maskWithColor(color: color), for: .normal)
        } else {
            let image = UIImage(named: "checkBoxOff.png")
            self.setImage(image?.maskWithColor(color: color), for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
