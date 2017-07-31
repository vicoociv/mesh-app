//
//  MessageTableViewCell.swift
//  mesh
//
//  Created by Victor Chien on 4/15/17.
//  Copyright © 2017 Victor Chien. All rights reserved.
//

import UIKit

class ToMessageTableViewCell: UITableViewCell {

    let screenWidth = UIScreen.main.bounds.width
    
    var status: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.textColor = UIColor.meshOrange
        label.font = UIFont(name: label.font.fontName, size: 12)
        return label
    }()

    var messageText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.lineBreakMode = .byWordWrapping
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        label.numberOfLines = 0
        return label
    }()
    
    var textBubble: Button = {
        let view = Button()
        view.backgroundColor = UIColor.meshOrange
        view.layer.cornerRadius = 18
        view.alpha = 0.8
        return view
    }()
    
    var photoView: UIImageView = {
        let photo = UIImageView()
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.layer.masksToBounds = true
        return photo
    }()
    
    private func setupView() {
        addSubview(status)

        if photoView.image != nil {
            addSubview(photoView)
            
            photoView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
            photoView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
            photoView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
            photoView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
            
            status.topAnchor.constraint(equalTo: photoView.bottomAnchor).isActive = true
            status.trailingAnchor.constraint(equalTo: photoView.trailingAnchor, constant: -7).isActive = true
        } else {
            addSubview(textBubble)
            addSubview(messageText)
        
            messageText.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
            messageText.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
            messageText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
            messageText.widthAnchor.constraint(lessThanOrEqualToConstant: 2 * screenWidth/3).isActive = true
        
            textBubble.topAnchor.constraint(equalTo: messageText.topAnchor, constant: -8).isActive = true
            textBubble.bottomAnchor.constraint(equalTo: messageText.bottomAnchor, constant: 8).isActive = true
            textBubble.leadingAnchor.constraint(equalTo: messageText.leadingAnchor, constant: -12).isActive = true
            textBubble.trailingAnchor.constraint(equalTo: messageText.trailingAnchor, constant: 12).isActive = true
            textBubble.widthAnchor.constraint(greaterThanOrEqualToConstant: 35).isActive = true
            
            status.topAnchor.constraint(equalTo: textBubble.bottomAnchor).isActive = true
            status.trailingAnchor.constraint(equalTo: textBubble.trailingAnchor, constant: -7).isActive = true
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
}
