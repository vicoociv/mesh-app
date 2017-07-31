//
//  MainViewController.swift
//  mesh
//
//  Created by Victor Chien on 7/31/17.
//  Copyright © 2017 Victor Chien. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var discoverList = [String]()
    var contactList = [String]()
    var selectedList = ListType.Contacts
    
    private var newContact: String!
    internal var displayList = [String]()
    internal var currentIndex = 0
    
    enum ListType {
        case Contacts
        case Discover
    }
    
    var screenTitle: Label = {
        let label = Label()
        label.text = "Chat"
        label.font = UIFont(name: "Helvetica Neue", size: 18)
        label.textAlignment = .center
        label.textColor = UIColor.black
        return label
    }()
    
    var navigationBar: View = {
        let view = View()
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.alpha = 0.95
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        
        let shadow = View()
        shadow.backgroundColor = UIColor.gray
        shadow.frame = CGRect(x: 0, y: 99.3, width: UIScreen.main.bounds.width, height: 0.7)
        view.addSubview(shadow)
        
        return view
    }()
    
    lazy var tabButton: UISegmentedControl = {
        let button = UISegmentedControl()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.insertSegment(with: nil, at: 0, animated: false)
        button.insertSegment(with: nil, at: 1, animated: false)
        button.setTitle("Contacts", forSegmentAt: 0)
        button.setTitle("Discover", forSegmentAt: 1)
        button.addTarget(self, action: #selector(listChange(sender:)), for: .valueChanged)
        button.selectedSegmentIndex = 0
        button.backgroundColor = UIColor.clear
        button.tintColor = UIColor.meshOrange
        return button
    }()
    
    @objc func listChange(sender: AnyObject) {
        if sender.selectedSegmentIndex == 0{
            displayList = contactList
            selectedList = .Contacts
        } else if sender.selectedSegmentIndex == 1{
            displayList = discoverList
            selectedList = .Discover
        }
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
    }

    lazy var tableView: TableView = {
        let table = TableView()
        table.backgroundColor = UIColor.white
        table.allowsSelection = true
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    private func setupView() {
        navigationBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        navigationBar.heightAnchor.constraint(equalToConstant: 100).isActive = true
        navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        screenTitle.topAnchor.constraint(equalTo: navigationBar.topAnchor, constant: 25).isActive = true
        screenTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        screenTitle.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor, constant: 16).isActive = true
        screenTitle.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor, constant: -16).isActive = true

        tabButton.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -12).isActive = true
        tabButton.heightAnchor.constraint(equalToConstant: 28).isActive = true
        tabButton.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor, constant: 50).isActive = true
        tabButton.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor, constant: -50).isActive = true
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.addSubview(navigationBar)
        view.addSubview(screenTitle)
        view.addSubview(tabButton)
        setupView()
        
        discoverList = SharingManager.sharedInstance.directConnections
        contactList = SharingManager.sharedInstance.contactList
        displayList = contactList
        
        tableView.register(GroupsTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "spacerCell")
        
        //to detect long press on table cells
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        self.tableView.addGestureRecognizer(longPressRecognizer)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //Handles confirmation of new contact with popup
    func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if selectedList == .Discover {
            if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
                
                let touchPoint = longPressGestureRecognizer.location(in: self.tableView)
                if let tempIndex = tableView.indexPathForRow(at: touchPoint) {
                    if tempIndex.row != 0 && tempIndex.row != 1 && tempIndex.row != discoverList.count + 1 {
                        newContact = discoverList[tempIndex.row]
                        let alertMessage = "Are you sure you want to add \(newContact) to your contacts?"
                        
                        let alert = UIAlertController(title: "Attention", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "cancel", style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) in
                            self.newContact = "" }))
                        alert.addAction(UIAlertAction(title: "add", style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) in
                            //makes sure can't add duplicates
                            if !(SharingManager.sharedInstance.contactList.contains(self.newContact)) {
                                SharingManager.sharedInstance.contactList.append(self.newContact)
                                self.contactList.append(self.newContact)
                            }
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @objc private func refresh(_ sender: UIBarButtonItem) {
        SharingManager.sharedInstance.networkService.refresh()
        discoverList = SharingManager.sharedInstance.directConnections
        if selectedList == .Discover {
            displayList = discoverList
        }
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedList == .Discover {
            return self.displayList.count + 3
        } else {
            return self.displayList.count + 2
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 100
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        currentIndex = indexPath.row
        if selectedList == .Discover {
            if currentIndex != 0 && currentIndex != discoverList.count + 2 {
                performSegue(withIdentifier: "showChat", sender: self)
            }
        } else {
            if currentIndex != 0 && currentIndex != contactList.count + 1 {
                performSegue(withIdentifier: "showChat", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChat" {
            tableView.deselectRow(at: IndexPath(row: currentIndex, section: 0), animated: false)
            let upcoming: ChatViewController = segue.destination as! ChatViewController
            
            if selectedList == .Discover && currentIndex == 1 {
                upcoming.chatType = .Public
                upcoming.contactName = "Public"
            } else if selectedList == .Discover{
                if SharingManager.sharedInstance.directConnections.count > 0 {
                    let contactNameTemp = self.discoverList[currentIndex - 1]
                    upcoming.chatType = .Direct
                    upcoming.contactName = contactNameTemp
                }
            } else if selectedList == .Contacts {
                if SharingManager.sharedInstance.contactList.count > 0 {
                    let contactNameTemp = self.contactList[currentIndex - 1]
                    upcoming.chatType = .Direct
                    upcoming.contactName = contactNameTemp
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tempIndex = indexPath.row
        
        if selectedList == .Discover {
            if tempIndex == 0 || tempIndex == discoverList.count + 2 {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "spacerCell", for: indexPath)
                return cell
            } else if tempIndex == 1 {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GroupsTableViewCell
                cell.titleLabel.text = "Public Chat"
                return cell
            } else {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GroupsTableViewCell
                cell.titleLabel.text = displayList[tempIndex - 1]
                return cell
            }
        } else {
            if tempIndex == 0 || tempIndex == contactList.count + 1 {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "spacerCell", for: indexPath)
                return cell
            } else {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GroupsTableViewCell
                cell.titleLabel.text = displayList[tempIndex - 1]
                return cell
            }
        }
    }
}
    
    

