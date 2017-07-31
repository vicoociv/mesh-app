//
//  GroupsTableViewCell.swift
//  fishBowl
//
//  Created by Victor Chien on 6/9/17.
//  Copyright © 2017 Victor Chien. All rights reserved.
//

import UIKit

class GroupsTableViewCell: UITableViewCell {
    
    var userImage: UserIcon = {
        let view = UserIcon()
//        let image = UIImage(named: "cloudLogoUnfilled.png")
//        view.imageView.image = image
        view.setBounds(dimensions: 55)
        return view
    }()
    
    var titleLabel: Label = {
        let label = Label()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.black
        label.font = UIFont(name: "Helvetica Neue", size: ConstraintHandler.getPercentage(18))
        return label
    }()
    
    var timeLabel: Label = {
        let label = Label()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.black
        label.font = UIFont(name: "Helvetica Neue", size: ConstraintHandler.getPercentage(15))
        label.text = "12:35 am"
        return label
    }()
    
    var previewLabel: Label = {
        let label = Label()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.black
        label.font = UIFont(name: "Helvetica Neue", size: ConstraintHandler.getPercentage(15))
        label.text = "I want to eat food with Vikings"
        return label
    }()
    
    lazy var checkBox: CheckBoxImage = {
        let view = CheckBoxImage(image: nil)
        view.setColor(color: UIColor.meshOrange)
        view.toggle(false)
        view.isHidden = true
        return view
    }()
    
    
    private func notificationActivated(_ indicator: Bool) {
        if indicator {
            userImage.circleOutline.layer.borderColor = UIColor.meshOrange.cgColor
            previewLabel.textColor = UIColor.black
            timeLabel.textColor = UIColor.black
        } else {
            userImage.circleOutline.layer.borderColor = UIColor.clear.cgColor
            previewLabel.textColor = UIColor.lightGray
            timeLabel.textColor = UIColor.lightGray
        }
    }
    
    func toggleSelection(_ indicator: Bool) {
        checkBox.toggle(indicator)
        if indicator {
            self.backgroundColor = UIColor.ultraLightGray
        } else {
            self.backgroundColor = UIColor.white
        }
    }
    
    //for selection mode
    func showCheckbox(_ indicator: Bool) {
        timeLabel.isHidden = indicator
        checkBox.isHidden = !indicator
        if !indicator {
            self.backgroundColor = UIColor.white
        }
    }
    
    private func setupView() {
        addSubview(userImage)
        addSubview(titleLabel)
        addSubview(previewLabel)
        addSubview(timeLabel)
        addSubview(checkBox)
        
        notificationActivated(true)
        
        checkBox.topAnchor.constraint(equalTo: userImage.topAnchor, constant: ConstraintHandler.getPercentage(12)).isActive = true
        checkBox.heightAnchor.constraint(equalToConstant: 36, relative: true).isActive = true
        checkBox.widthAnchor.constraint(equalToConstant: 36, relative: true).isActive = true
        checkBox.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15, relative: true).isActive = true
        
        userImage.widthAnchor.constraint(equalToConstant: 55, relative: true).isActive = true
        userImage.heightAnchor.constraint(equalToConstant: 55, relative: true).isActive = true
        userImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 12, relative: true).isActive = true
        userImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12, relative: true).isActive = true
        userImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16, relative: true).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: userImage.topAnchor, constant: 3).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: previewLabel.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 16, relative: true).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: -10).isActive = true
        
        previewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16, relative: true).isActive = true
        previewLabel.bottomAnchor.constraint(equalTo: userImage.bottomAnchor, constant: -5, relative: true).isActive = true
        previewLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        previewLabel.trailingAnchor.constraint(equalTo: timeLabel.trailingAnchor).isActive = true
        
        timeLabel.widthAnchor.constraint(equalToConstant: 70, relative: true).isActive = true
        timeLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -7, relative: true).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15, relative: true).isActive = true
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
}
