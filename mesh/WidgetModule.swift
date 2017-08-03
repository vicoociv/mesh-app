//
//  WidgetModule.swift
//  fishBowl
//
//  Created by Victor Chien on 5/14/17.
//  Copyright © 2017 Victor Chien. All rights reserved.
//

import UIKit


class NavigationBar: View {
    
    lazy var backButton: Button = {
        let button = Button()
        let image = UIImage(named: "backButton.png")
        button.setImage(image?.maskWithColor(color: UIColor.meshOrange), for: .normal)
        return button
    }()
    
    lazy var refreshButton: Button = {
        let button = Button()
        let image = UIImage(named: "backButton.png")
        button.setImage(image?.maskWithColor(color: UIColor.meshOrange), for: .normal)
        return button
    }()
    
    var shadowView: View = {
        let shadow = View()
        shadow.backgroundColor = UIColor.gray
        shadow.frame = CGRect(x: 0, y: 69.3, width: UIScreen.main.bounds.width, height: 0.7)
        return shadow
    }()
    
    private func setupView() {
        addSubview(refreshButton)
        addSubview(backButton)
        addSubview(shadowView)
        
        refreshButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 25).isActive = true
        refreshButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        refreshButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        refreshButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10).isActive = true

        backButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 25).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        
        shadowView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        shadowView.heightAnchor.constraint(equalToConstant: 0.7).isActive = true
        shadowView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        shadowView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.masksToBounds = true
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.alpha = 0.95
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TabBar: UISegmentedControl {
    
    //if don't override this then will crash
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.tintColor = UIColor.meshOrange
        self.backgroundColor = UIColor.clear
        let font = UIFont.systemFont(ofSize: 12)
        self.setTitleTextAttributes([NSFontAttributeName: font],
                                                for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDefaultConstraints(topView: UIView, generalView: UIView) {
        self.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -10).isActive = true
        self.leadingAnchor.constraint(equalTo: generalView.leadingAnchor, constant: 40).isActive = true
        self.trailingAnchor.constraint(equalTo: generalView.trailingAnchor, constant: -40).isActive = true
        self.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}


class ScrollView: UIScrollView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class TableView: UITableView {
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.clear.cgColor
        self.separatorStyle = .none
        self.isUserInteractionEnabled = true
        self.isScrollEnabled = true
        self.bounces = true
        self.allowsSelection = false
        
        //automatic resizing of table cells
        self.rowHeight = UITableViewAutomaticDimension
        self.estimatedRowHeight = 120.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Button: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ImageView: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class View: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Label: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Circle: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        self.layer.borderWidth = 1.7
        self.layer.borderColor = UIColor.clear.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TextField: UITextField {
    //customizable property
    var fontSize: CGFloat = 17
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.masksToBounds = true
        
        self.backgroundColor = UIColor.clear
        self.tintColor = UIColor.lightGray
        self.layer.borderColor = UIColor.lightGray.cgColor
        
        self.autocorrectionType = .default
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 0.7
        
        self.font = UIFont(name: "Helvetica Neue", size: fontSize)
    }
    
    //indents the text on both ends since rounded edges covers up text
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width - 10, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width - 10, height: bounds.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
