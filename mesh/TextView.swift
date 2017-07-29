//
//  TextView.swift
//  fishBowl
//
//  Created by Victor Chien on 7/10/17.
//  Copyright © 2017 Victor Chien. All rights reserved.
//

import Foundation
import UIKit

class TextView: UITextView {
    
    //customizable properties
    var expandable: Bool = false
    var maxHeight: CGFloat = 100
    var fontSize: CGFloat = 17
    var placeHolder: String = ""
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.clear
        self.tintColor = UIColor.lightGray
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.autocorrectionType = .default
        
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 0.7
        
        //top left bottom right spacing
        self.textContainerInset = UIEdgeInsetsMake(5, 10, 5, 10)
        self.font = UIFont(name: "Helvetica Neue", size: fontSize)
        
        self.isScrollEnabled = true
        self.bounces = false
        
        //adding placeholder
        self.addSubview(placeHolderLabel)
        placeHolderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        placeHolderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(UITextInputDelegate.textDidChange(_:)), name: Notification.Name.UITextViewTextDidChange, object: self)
    }
    
    @objc private func textDidChange(_ note: Notification) {
        if expandable {
            invalidateIntrinsicContentSize()
        }
        
        if self.text == "" {
            self.enablePlaceHolder()
        } else {
            self.disablePlaceholder()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        
        //only does this for expanding textViews
        if expandable {
            if size.height == UIViewNoIntrinsicMetric {
                // force layout
                layoutManager.glyphRange(for: textContainer)
                size.height = layoutManager.usedRect(for: textContainer).height + textContainerInset.top + textContainerInset.bottom
            }
            
            if maxHeight > 0.0 && size.height > maxHeight {
                size.height = maxHeight
                if !isScrollEnabled {
                    isScrollEnabled = true
                }
            } else if isScrollEnabled {
                isScrollEnabled = false
            }
        }
        return size
    }
    
    private var placeHolderLabel: Label = {
        let label = Label()
        label.textColor = UIColor.lightGray
        label.backgroundColor = UIColor.clear
        label.font = UIFont(name: "Helvetica Neue", size: 17)
        return label
    }()
    
    func setPlaceholder(placeholder: String, alignment: String) {
        placeHolderLabel.text = placeholder
        if alignment == "center" {
            placeHolderLabel.textAlignment = .center
        } else if alignment == "right" {
            placeHolderLabel.textAlignment = .right
        } else {
            placeHolderLabel.textAlignment = .left
        }
    }
    
    func enablePlaceHolder() {
        placeHolderLabel.isHidden = false
    }
    
    func disablePlaceholder() {
        placeHolderLabel.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
