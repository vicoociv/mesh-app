//
//  ChannelsViewController.swift
//  mesh
//
//  Created by Victor Chien on 12/28/16.
//  Copyright © 2016 Victor Chien. All rights reserved.
//

import UIKit

class ChannelsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabButton: UISegmentedControl!
    @IBOutlet weak var tabButton2: UISegmentedControl!
    
    var discoverList = [String]()
    var contactList = [String]()
    var selectedList = "Contacts"
    var newContact = ""
    
    //currently for public chat
    var displayList = [String]()
    
    class TabBar: UITabBar {
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            var sizeThatFits = super.sizeThatFits(size)
            sizeThatFits.height = 38
            
            return sizeThatFits
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabButton2.selectedSegmentIndex = 1
        
        discoverList = SharingManager.sharedInstance.directConnections
        contactList = SharingManager.sharedInstance.contactList
        displayList = contactList
        
        tabButton.frame = CGRect(x: tabButton.frame.origin.x, y: tabButton.frame.origin.y, width: tabButton.frame.size.width, height: 90);

        
        //to detect long press on table
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        self.tableView.addGestureRecognizer(longPressRecognizer)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
//Handles confirmation of new contact with popup
    func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if selectedList == "Discover" {
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            let touchPoint = longPressGestureRecognizer.location(in: self.tableView)
            if let tempIndex = tableView.indexPathForRow(at: touchPoint) {
                
                let tempName = discoverList[tempIndex.row]
                newContact = tempName
                let alertMessage = "Are you sure you want to add \(tempName) to your contacts?"

                //creates a default alert popup
                let alert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
                
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
    
    
 //TableView Stuff
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.displayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! ContactsTableViewCell
        cell.dicoverContactLabel.text = displayList[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if selectedList == "Contacts" {
            performSegue(withIdentifier: "showPublicChat", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if selectedList == "Contacts" && (segue.identifier == "showPublicChat") {
            let upcoming: ViewController = segue.destination as! ViewController
            if let tempIndex = tableView.indexPathForSelectedRow{
                let cellIndex = tempIndex.row
                
                //passing info to second view controller
                if SharingManager.sharedInstance.contactList.count > 0{
                    let contactNameTemp = self.contactList[cellIndex]
                    upcoming.chatType = "direct"
                    upcoming.contactName = contactNameTemp//passing name of contact
                    upcoming.infoList = DataProcessor.filterMessages(sender: contactNameTemp, recipient: SharingManager.sharedInstance.username, messageList: SharingManager.sharedInstance.messageList)
                } else {
                    upcoming.contactName = ""
                    upcoming.chatType = ""
                    upcoming.infoList = [String]()
                }
            }
        }
    }
    

    
//Buttons Stuff
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        //SharingManager.sharedInstance.networkService.refresh()
        discoverList = SharingManager.sharedInstance.directConnections
        if selectedList == "Discover" {
            displayList = discoverList
        }
        self.tableView.reloadData()
    }
    
    //tabular button implementation
    @IBAction func listChange(_ sender: AnyObject) {
        if tabButton.selectedSegmentIndex == 0{
            displayList = contactList
            selectedList = "Contacts"
        }
        else if tabButton.selectedSegmentIndex == 1{
            displayList = discoverList
            selectedList = "Discover"
        }
        else if tabButton.selectedSegmentIndex == 2{
            self.performSegue(withIdentifier: "showPublicChat", sender: self)
        }
        tableView.reloadData()
    }
    
    @IBAction func switchView(_ sender: UISegmentedControl) {
        if tabButton2.selectedSegmentIndex == 1{
            self.performSegue(withIdentifier: "showMapView", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
