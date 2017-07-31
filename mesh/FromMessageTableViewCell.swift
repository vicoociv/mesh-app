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
    
    var contactBubble: Button = {
        let button = Button()
        button.layer.cornerRadius = 20
        return button
    }()
    
    var messageText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = UIColor.black
        return label
    }()
    
    var textBubble: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.mediumGray
        view.layer.cornerRadius = 17
        view.alpha = 0.8
        return view
    }()
    
    private func setupView() {
        contactBubble.backgroundColor = UIColor.lightGray
        addSubview(textBubble)
        addSubview(messageText)
        addSubview(nameLabel)
        addSubview(contactBubble)
        
        messageText.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        messageText.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        messageText.leadingAnchor.constraint(equalTo: contactBubble.trailingAnchor, constant: 20).isActive = true
        messageText.widthAnchor.constraint(lessThanOrEqualToConstant: 2 * screenWidth/3).isActive = true
        
        textBubble.topAnchor.constraint(equalTo: messageText.topAnchor, constant: -8).isActive = true
        textBubble.bottomAnchor.constraint(equalTo: messageText.bottomAnchor, constant: 8).isActive = true
        textBubble.leadingAnchor.constraint(equalTo: messageText.leadingAnchor, constant: -12).isActive = true
        textBubble.trailingAnchor.constraint(equalTo: messageText.trailingAnchor, constant: 12).isActive = true
        textBubble.widthAnchor.constraint(greaterThanOrEqualToConstant: 35).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: textBubble.bottomAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: textBubble.leadingAnchor, constant: 7).isActive = true
        
        contactBubble.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        contactBubble.bottomAnchor.constraint(equalTo: messageText.bottomAnchor).isActive = true
        contactBubble.heightAnchor.constraint(equalToConstant: 25).isActive = true
        contactBubble.widthAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
}
