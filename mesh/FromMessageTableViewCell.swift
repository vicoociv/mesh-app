//
//  MessageTableViewCell.swift
//  mesh
//
//  Created by Victor Chien on 4/15/17.
//  Copyright © 2017 Victor Chien. All rights reserved.
//

import UIKit

class FromMessageTableViewCell: UITableViewCell {
    
    let screenWidth = UIScreen.main.bounds.width
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.textColor = UIColor.lightGray
        label.font = UIFont(name: label.font.fontName, size: 12)
        return label
    }()
    
    var contactBubble: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layoutIfNeeded()
        button.layer.masksToBounds = true
        return button
    }()
    
    var messageText: PaddedLabel = {
        let label = PaddedLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byCharWrapping
        label.backgroundColor = UIColor(red: 240/255, green: 236/255, blue: 233/255, alpha: 1.0)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 15
        label.numberOfLines = 0
        return label
    }()
    
    func setupFromView() {
        messageText.textColor = UIColor.black
        contactBubble.backgroundColor = UIColor.lightGray
        addSubview(messageText)
        addSubview(nameLabel)
        addSubview(contactBubble)
        
        contactBubble.frame = CGRect(x: contactBubble.frame.origin.x, y: contactBubble.frame.origin.y, width: 100, height: 100)
        contactBubble.layer.cornerRadius = 25
        
        self.addConstraints(messageText.constrainSidesView(indicator: false, to: self, top: 10, bottom: 20, right: -60, left: 60))
        self.addConstraint(messageText.constrainWidth(to: self, constant: screenWidth/3))
        self.addConstraints(contactBubble.constrainSidesView(indicator: false, to: self, top: 20, bottom: -60, right: -60, left: 15))
        self.addConstraints(nameLabel.constrainSidesView(indicator: false, to: self, top: -60, bottom: 0, right: -60, left: 65))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupFromView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
