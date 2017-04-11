//
//  ViewController.swift
//  mesh
//
//  Created by Victor Chien on 11/27/16.
//  Copyright © 2016 Victor Chien. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var connectionsLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    //to shift the view up when keyboard appears
    @IBOutlet weak var chatScrollView: UIScrollView!
    
    //stores info
    var infoList = [String]()
    var contactName = "Public Chat"
    var username = "public"
    var chatType = "public"
    var index: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if chatType == "public" {
            infoList = DataProcessor.filterMessages(sender: "public", recipient: "public", messageList: SharingManager.sharedInstance.messageList)
        }
        
        //sets initial positon and height of the UI elements
        self.chatScrollView.frame = CGRect(x: 0.0, y: 60.0, width: Double(self.view.frame.width), height: Double(self.view.frame.height - 60))
        
        self.tableView.frame = CGRect(x: 0.0, y: 0.0, width: Double(self.chatScrollView.frame.width), height: Double(self.chatScrollView.frame.height - 90))
        self.tableView.layer.borderWidth = 0.5
        self.tableView.layer.borderColor = UIColor.black.cgColor
        
        self.textField.frame = CGRect(x: 14.0, y: Double(self.tableView.frame.height), width: Double(self.chatScrollView.frame.width - 28), height: 60.0)
        self.connectionsLabel.frame = CGRect(x: 14.0, y: Double(self.tableView.frame.height + 60), width: 133.0, height: 17.0)
        self.clearButton.frame = CGRect(x: Double(self.tableView.frame.width - 133), y: Double(self.tableView.frame.height + 60), width: 53.0, height: 24.0)
        self.sendButton.frame = CGRect(x: Double(self.tableView.frame.width - 85), y: Double(self.tableView.frame.height + 60), width: 85.0, height: 25.0)
        
        
        //setting the title of the navigation bar to contact or public (default)
        self.navigationBar.topItem?.title = contactName
        
        //setting connections count
        self.connectionsLabel.text = "Connections: \(SharingManager.sharedInstance.directConnections.count)"
        
        //getting stored username
        username = SharingManager.sharedInstance.username
        
        //removes lines between cells
        self.tableView.separatorStyle = .none
        
        //receives notification and updates table
        NotificationCenter.default.addObserver(forName:Notification.Name(rawValue:"MessageNotification"), object:nil, queue:nil) {
                        notification in
            self.updateMessageList()
            self.scrollToLatest()
            self.tableView.reloadData()
        }
        
        //removing keyboard on tap
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //shifts view up when keyboard is activated
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

//      for automatic resizing of cell height
        self.tableView.estimatedRowHeight = 120.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
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
            self.tableView.frame = CGRect(x: 0.0, y: Double(keyboardSize.height), width: Double(chatScrollView.frame.width), height: Double(chatScrollView.frame.height - keyboardSize.height - 80))
            
            scrollToLatest()
            
            //scrolls view up
            chatScrollView.setContentOffset(CGPoint(x: 0.0, y: keyboardSize.height), animated: false)
            tableView.reloadData()
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        //resets position and height of tableView
        self.tableView.frame = CGRect(x: 0.0, y: 0.0, width: Double(chatScrollView.frame.width), height: Double(chatScrollView.frame.height - 80))
        
        //scrolls view back down
        chatScrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: false)
        tableView.reloadData()
    }
    
    //updates the infoList by filtering main messageList in Sharing Manager
    private func updateMessageList() {
        if chatType == "direct" {
            infoList = DataProcessor.filterMessages(sender: contactName, recipient: username, messageList: SharingManager.sharedInstance.messageList)
        } else {
            infoList = DataProcessor.filterMessages(sender: "public", recipient: "public", messageList: SharingManager.sharedInstance.messageList)
        }
    }
    
    //scrolls to most current cell. Independent method so does not interfere with the dynamic cell height adjustment.
    private func scrollToLatest() {
        self.tableView.reloadData()
        if index != nil {
            let length = infoList.count
            if length > 0 {
                index.row = infoList.count - 1
                tableView.scrollToRow(at: index, at: UITableViewScrollPosition.top, animated: true)
            }
        }
    }
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        //SharingManager.sharedInstance.networkService.refresh()
        self.connectionsLabel.text = "Connections: \(SharingManager.sharedInstance.directConnections.count)"
        self.updateMessageList()
        self.tableView.reloadData()
    }
    
    //sends the data
    @IBAction func send() {
            if let s = textField.text {
                if s != "" {
                    textField.text = "";
                    if chatType == "direct" {
                        SharingManager.sharedInstance.addMessage(username: username, msg: s, contactName: contactName)
                    } else if chatType == "public"{
                        SharingManager.sharedInstance.addMessage(username: "public", msg: s, contactName: "public")
                    }
                    
                    self.updateMessageList()
                    scrollToLatest()
                    tableView.reloadData()
                }
            }
    }
    
    @IBAction func clear(_ sender: UIButton) {
        textField.text = "";
        infoList.removeAll()
        SharingManager.sharedInstance.meshDatabase.delete(toDelete: "message")
        SharingManager.sharedInstance.messageList.removeAll()
        tableView.reloadData()
    }
    
    
    
//Table stuff
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int  {
        return 1
    }
    
    //table view stuff
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.infoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = self.infoList[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        self.index = indexPath

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

