//
//  TabBarViewController.swift
//  fishBowl
//
//  Created by Victor Chien on 6/18/17.
//  Copyright © 2017 Victor Chien. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isTranslucent = true
        tabBar.tintColor = UIColor.meshOrange
        
        tabBar.items?[0].title = "Chat"
        tabBar.items?[1].title = "Maps"
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 15)!], for: .normal)
        
        //set this in root view controller for effect to carry over to following VC's
        self.navigationController?.navigationBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
