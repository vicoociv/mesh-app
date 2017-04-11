//
//  CustomTableViewCell.swift
//  mesh
//
//  Created by Victor Chien on 12/3/16.
//  Copyright © 2016 Victor Chien. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    


//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        var messageLabel = UILabel()
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        
//        messageLabel.translatesAutoresizingMaskIntoConstraints = false
//        messageLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
//        messageLabel.numberOfLines = 0
//        self.contentView.addSubview(messageLabel)
//        
//        self.contentView.addConstraints(
//            NSLayoutConstraint.constraints(
//                views: [ "title" : messageLabel],
//                visualFormats: "H:|-5-[title]-5-|"))
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
    //}

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
