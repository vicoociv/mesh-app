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
    
    var nameLabel: Label = {
        let label = Label()
        label.font = UIFont(name: label.font.fontName, size: 12)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    var userIcon: UserIcon = {
        let icon = UserIcon()
        icon.setBounds(dimensions: 40)
        let image = UIImage(named: "userIcon.png")
        icon.imageView.image = image?.maskWithColor(color: UIColor.gray)
        return icon
    }()
    
    var messageText: Label = {
        let label = Label()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = UIColor.black
        return label
    }()
    
    var textBubble: View = {
        let view = View()
        view.backgroundColor = UIColor.mediumGray
        view.layer.cornerRadius = 18
        view.alpha = 0.8
        return view
    }()
    
    private func setupView() {
        addSubview(textBubble)
        addSubview(messageText)
        addSubview(nameLabel)
        addSubview(userIcon)
        
        messageText.topAnchor.constraint(equalTo: self.topAnchor, constant: 30).isActive = true
        messageText.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        messageText.leadingAnchor.constraint(equalTo: userIcon.trailingAnchor, constant: 20).isActive = true
        messageText.widthAnchor.constraint(lessThanOrEqualToConstant: 2 * screenWidth/3).isActive = true
        
        textBubble.topAnchor.constraint(equalTo: messageText.topAnchor, constant: -8).isActive = true
        textBubble.bottomAnchor.constraint(equalTo: messageText.bottomAnchor, constant: 8).isActive = true
        textBubble.leadingAnchor.constraint(equalTo: messageText.leadingAnchor, constant: -12).isActive = true
        textBubble.trailingAnchor.constraint(equalTo: messageText.trailingAnchor, constant: 12).isActive = true
        textBubble.widthAnchor.constraint(greaterThanOrEqualToConstant: 35).isActive = true
        
        nameLabel.bottomAnchor.constraint(equalTo: textBubble.topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: textBubble.leadingAnchor, constant: 7).isActive = true
        
        userIcon.topAnchor.constraint(equalTo: textBubble.topAnchor, constant: -2).isActive = true
        userIcon.heightAnchor.constraint(equalToConstant: 40).isActive = true
        userIcon.widthAnchor.constraint(equalToConstant: 40).isActive = true
        userIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
}
