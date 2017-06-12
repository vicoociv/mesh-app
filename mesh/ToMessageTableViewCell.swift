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
        label.textColor = UIColor.orange
        label.font = UIFont(name: label.font.fontName, size: 12)
        return label
    }()

    var messageText: PaddedLabel = {
        let label = PaddedLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byCharWrapping
        label.backgroundColor = UIColor.orange
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 15
        label.numberOfLines = 0
        return label
    }()
    
    func setupToView() {
        messageText.textColor = UIColor.white
        addSubview(messageText)
        addSubview(status)

        self.addConstraints(messageText.constrainSidesView(indicator: true, to: self, top: 10, bottom: 20, right: 20, left: -60))
        self.addConstraint(messageText.constrainWidth(to: self, constant: screenWidth/3))
        self.addConstraints(status.constrainSidesView(indicator: true, to: self, top: -60, bottom: 0, right: 25, left: -60))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupToView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
