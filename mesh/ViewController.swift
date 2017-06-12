//
//  ViewController.swift
//  mesh
//
//  Created by Victor Chien on 11/27/16.
//  Copyright © 2016 Victor Chien. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var connectionsLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var contactName = "Public Chat"
    var username = "public"
    var chatType = chatStatus.Public
    var messageList: [Message]!
    var index: IndexPath!
    
    let screenWidth = UIScreen.main.bounds.width
    
    enum chatStatus {
        case Public
        case Direct
    }
    
    private func setUpLayout() {
        //sets initial positon and height of the UI elements
        self.scrollView.frame = CGRect(x: 0.0, y: 60.0, width: Double(self.view.frame.width), height: Double(self.view.frame.height - 60))
        
        self.tableView.frame = CGRect(x: 0.0, y: 0.0, width: Double(self.scrollView.frame.width), height: Double(self.scrollView.frame.height - 90))
        self.tableView.layer.borderWidth = 0.5
        self.tableView.layer.borderColor = UIColor.black.cgColor
        //self.tableView.register(ToMessageTableViewCell.self, forCellReuseIdentifier: "cell1")
        
        self.textField.frame = CGRect(x: 14.0, y: Double(self.tableView.frame.height), width: Double(self.scrollView.frame.width - 28), height: 60.0)
        self.connectionsLabel.frame = CGRect(x: 14.0, y: Double(self.tableView.frame.height + 60), width: 133.0, height: 17.0)
        self.clearButton.frame = CGRect(x: Double(self.tableView.frame.width - 65), y: Double(self.tableView.frame.height + 60), width: 53.0, height: 24.0)
        
        
        //setting the title of the navigation bar to contact or public (default)
        self.navigationBar.topItem?.title = contactName
        
        //setting connections count
        self.connectionsLabel.text = "Connections: \(SharingManager.sharedInstance.directConnections.count)"
        
        //removes lines between cells
        self.tableView.separatorStyle = .none
        
        //changes return key text
        textField.returnKeyType = .send
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateMessageList()
        setUpLayout()
        username = SharingManager.sharedInstance.username
        
        //receives notification and updates table
    NotificationCenter.default.addObserver(forName:Notification.Name(rawValue:"MessageNotification"), object:nil, queue:nil) {
                        notification in
            self.updateMessageList()
            self.scrollToLatest()
            self.tableView.reloadData()
        }
    NotificationCenter.default.addObserver(forName:Notification.Name(rawValue:"NewConnectionFound"), object:nil, queue:nil) {
            notification in
            //self.sendUnsentMessages(notification: notification)
        }
        
        //removing keyboard on tap
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //shifts view up when keyboard is activated
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

//      for automatic resizing of cell height
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 120.0
        self.tableView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            //shifts position and changes height of tableView
            tableView.frame = CGRect(x: 0.0, y: Double(keyboardSize.height), width: Double(scrollView.frame.width), height: Double(scrollView.frame.height - keyboardSize.height - 80))
            scrollToLatest()
            
            //scrolls view up
            scrollView.setContentOffset(CGPoint(x: 0.0, y: keyboardSize.height), animated: false)
            tableView.reloadData()
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        //resets position and height of tableView
        tableView.frame = CGRect(x: 0.0, y: 0.0, width: Double(scrollView.frame.width), height: Double(scrollView.frame.height - 80))
        //scrolls view back down
        scrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: false)
        tableView.reloadData()
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        if let s = textField.text {
            if s != "" {
                textField.text = "";
                if chatType == .Direct {
                    SharingManager.sharedInstance.addMessage(unsent: false, username: username, msg: s, contactName: contactName)
                } else if chatType == .Public{
                    SharingManager.sharedInstance.addMessage(unsent: false, username: "public", msg: s, contactName: "public")
                }
                
                //add to info list here
                self.updateMessageList()
                scrollToLatest()
                tableView.reloadData()
            }
        }
    }
    
    
    func sendUnsentMessages(notification: Notification) {
        if let newContactName = notification.userInfo?["newContact"] as? String{
            if let tempUnsentMessageList = SharingManager.sharedInstance.unsentMessageDict[newContactName] {
                print("hello\n\n \(newContactName) \(tempUnsentMessageList.count)")
                //CHECK HERE!!!!!!
                var i = 0;
                for msg in tempUnsentMessageList {
                    SharingManager.sharedInstance.addMessage(unsent: true, username: msg.sender, msg: msg.message, contactName: msg.recipient)
                    SharingManager.sharedInstance.meshDatabase.deleteMessage(msgToDelete: msg)
                    SharingManager.sharedInstance.unsentMessageDict[newContactName]?.remove(at: i)
                    print("Step 1")
                    i += 1
                }
            }
        } else {
            NSLog("s", "No message to send")
        }
    }
    
    //updates the infoList by filtering main messageList in Sharing Manager
    private func updateMessageList() {
        if chatType == .Public {
            if let list = SharingManager.sharedInstance.messageDict["public"] {
                messageList = list
            } else {
                messageList = []
            }
        } else if chatType == .Direct{
            if let list = SharingManager.sharedInstance.messageDict[contactName] {
                messageList = list
            } else {
                messageList = []
            }
        } else {
            messageList = []
        }
    }
    
    //scrolls to most current cell. Independent method so does not interfere with the dynamic cell height adjustment.
    private func scrollToLatest() {
        self.tableView.reloadData()
        if index != nil {
            let length = messageList.count
            if length > 0 {
                index.row = messageList.count - 1
                tableView.scrollToRow(at: index, at: UITableViewScrollPosition.top, animated: true)
            }
        }
    }
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        SharingManager.sharedInstance.networkService.refresh()
        self.connectionsLabel.text = "Connections: \(SharingManager.sharedInstance.directConnections.count)"
        self.updateMessageList()
        self.tableView.reloadData()
    }
    
    //for testing puposes. Remove later
    @IBAction func clear(_ sender: UIButton) {
        textField.text = "";
        messageList.removeAll()
        SharingManager.sharedInstance.meshDatabase.delete(toDelete: "message")
        SharingManager.sharedInstance.meshDatabase.delete(toDelete: "unsentMessage")
        SharingManager.sharedInstance.messageDict.removeAll()
        tableView.reloadData()
    }
    
    
//Table stuff
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int  {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.index = indexPath
        let tempMessage = self.messageList[indexPath.row]
        
        if tempMessage.getSender() == "me" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "toCell", for: indexPath) as! ToMessageTableViewCell
            cell.messageText.text = tempMessage.getMessage()
            cell.status.text = "sent"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "fromCell", for: indexPath) as! FromMessageTableViewCell
            cell.messageText.text = tempMessage.getMessage()
            cell.nameLabel.text = tempMessage.getSender()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

