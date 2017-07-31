//
//  UserIcon.swift
//  fishBowl
//
//  Created by Victor Chien on 7/28/17.
//  Copyright © 2017 Victor Chien. All rights reserved.
//

import Foundation
import UIKit

class UserIcon: View {
    
    var imageView: UIImageView = {
        let view = UIImageView(image: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.ultraLightGray
        return view
    }()
    
    var circleOutline: Circle = {
        let view = Circle()
        return view
    }()
    
    var circleMask: Circle = {
        let view = Circle()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var imageButton: Button = {
        let button = Button()
        button.backgroundColor = UIColor.clear
        return button
    }()
    
    func setBounds(dimensions: CGFloat) {
        circleOutline.layer.cornerRadius = dimensions/2
        circleMask.layer.cornerRadius = dimensions/2 - 4
        circleMask.frame = CGRect(x: 0, y: 0, width: dimensions - 8, height: dimensions - 8)
    }
    
    private func setupView() {
        addSubview(imageView)
        addSubview(circleOutline)
        addSubview(imageButton)
        
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4).isActive = true
        
        circleOutline.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        circleOutline.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        circleOutline.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        circleOutline.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        imageButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        imageButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        imageButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupView()
        imageView.mask = circleMask
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
