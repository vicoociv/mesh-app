//
//  ChatViewController.swift
//  mesh
//
//  Created by Victor Chien on 7/28/17.
//  Copyright © 2017 Victor Chien. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITextViewDelegate {
    
    var contactName: String!
    var username: String!
    var chatType = chatStatus.Public

    internal var index: IndexPath!
    internal var messageList: [Message] = []
    internal var constraintHandler = ConstraintHandler()
    internal var imagePicker = UIImagePickerController()
    
    enum chatStatus {
        case Public
        case Direct
    }
    
    var navigationBar: NavigationBar = {
        let view = NavigationBar()
        view.backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        return view
    }()
    
    @objc private func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    lazy var tableView: TableView = {
        let table = TableView()
        table.delegate = self
        table.dataSource = self
        table.keyboardDismissMode = .none
        table.backgroundColor = UIColor.white
        return table
    }()
    
    lazy var textView: TextView = {
        let field = TextView()
        field.delegate = self
        field.expandable = true
        field.backgroundColor = UIColor.clear
        field.layer.borderColor = UIColor.gray.cgColor
        field.setPlaceholder(placeholder: "Send a message...", alignment: "left")
        return field
    }()
    
    var textViewBackground: View = {
        let view = View()
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.alpha = 0.95
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        
        let shadowLayer = View()
        shadowLayer.backgroundColor = UIColor.lightGray
        shadowLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0.7)
        view.addSubview(shadowLayer)
        
        return view
    }()
    
    lazy var sendButton: Button = {
        let button = Button()
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        let image = UIImage(named: "sendArrow.png")
        button.setImage(image?.maskWithColor(color: UIColor.meshOrange), for: .normal)
        button.isHidden = true
        return button
    }()
    
    @objc private func sendMessage() {
        let message = textView.text
        
        //deletes white spaces and new lines
        let trimmedMessage = message?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if trimmedMessage != "" {
            SharingManager.sharedInstance.addMessage(sent: true, username: username, msg: message!, contactName: contactName)
            
            textView.text = ""
            textView.invalidateIntrinsicContentSize()
            textView.enablePlaceHolder()
            constraintHandler.getConstraint(object: "textView", type: "height").isActive = true
            UIView.animate(withDuration: 0.3) {self.view.layoutIfNeeded()}
            
            updateMessageList()
            tableView.reloadData()
            scrollToLatest()
        }
    }
    lazy var attachmentButton: Button = {
        let button = Button()
        let image = UIImage(named: "paperclip.png")
        button.setImage(image?.maskWithColor(color: UIColor.meshOrange), for: .normal)
        button.addTarget(self, action: #selector(clear), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    //for testing puposes. Remove later
    @objc private func clear() {
        textView.text = "";
        messageList.removeAll()
        SharingManager.sharedInstance.meshDatabase.delete(toDelete: "message")
        SharingManager.sharedInstance.meshDatabase.delete(toDelete: "unsentMessage")
        SharingManager.sharedInstance.messageDict.removeAll()
        tableView.reloadData()
    }
    
    @objc private func openPhotos() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    //checks if text changed
    func textViewDidChange(_ textView: UITextView) {
        //in order to reset textViewHeight after sending a message greater than 100 in height.
        if textView.text == "" {
            constraintHandler.getConstraint(object: "textView", type: "height").isActive = true
        } else {
            constraintHandler.getConstraint(object: "textView", type: "height").isActive = false
        }
        //fixes spacing issue when go past limit and come back when deleting
        self.view.layoutIfNeeded()
    }
    
    internal func setupWordsView() {
        expandTextView(false)
        shiftViewUp(false)
        
        navigationBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        navigationBar.heightAnchor.constraint(equalToConstant: 70).isActive = true
        navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        textViewBackground.topAnchor.constraint(equalTo: textView.topAnchor, constant: -10).isActive = true
        textViewBackground.bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: 15).isActive = true
        textViewBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        textViewBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        sendButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: textView.bottomAnchor).isActive = true
        sendButton.leadingAnchor.constraint(equalTo: textView.trailingAnchor, constant: 5).isActive = true
        
        attachmentButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        attachmentButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        attachmentButton.bottomAnchor.constraint(equalTo: textView.bottomAnchor).isActive = true
        attachmentButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 7).isActive = true
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: textViewBackground.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    internal func setupDynamicConstraints() {
        constraintHandler.addConstraint(object: "textView", type: "height", constraint: textView.heightAnchor.constraint(equalToConstant: 30.5))
        constraintHandler.addConstraint(object: "textView", type: "bottomUp", constraint: textView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -(216 + 10)))
        constraintHandler.addConstraint(object: "textView", type: "bottomDown", constraint: textView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10))
        constraintHandler.addConstraint(object: "textView", type: "leftShrink", constraint: textView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 60))
        constraintHandler.addConstraint(object: "textView", type: "leftExpand", constraint: textView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40))
        constraintHandler.addConstraint(object: "textView", type: "rightShrink", constraint: textView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -60))
        constraintHandler.addConstraint(object: "textView", type: "rightExpand", constraint: textView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40))
    }
    
    internal func setupView() {
        view.addSubview(tableView)
        view.addSubview(navigationBar)
        view.addSubview(textViewBackground)
        view.addSubview(textView)
        view.addSubview(sendButton)
        view.addSubview(attachmentButton)
        
        tableView.register(ToMessageTableViewCell.self, forCellReuseIdentifier: "toCell")
        tableView.register(FromMessageTableViewCell.self, forCellReuseIdentifier: "fromCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "spacerCell")
        
        setupDynamicConstraints()
        setupWordsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateMessageList()
        username = SharingManager.sharedInstance.username
        
        if contactName == "public" {
            navigationBar.barTitle.text = "Public Chat"
        } else {
            navigationBar.barTitle.text = contactName
        }
        setupView()
        
        //removing keyboard on tap
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(forName:Notification.Name(rawValue:"MessageNotification"), object:nil, queue:nil) {
            notification in
            self.updateMessageList()
            self.tableView.reloadData()
            self.scrollToLatest()
        }
        NotificationCenter.default.addObserver(forName:Notification.Name(rawValue:"NewConnectionFound"), object:nil, queue:nil) {
            notification in
            //self.sendUnsentMessages(notification: notification)
            //only if contact is in unsent message list
        }
        
        //shifts view up when keyboard is activated
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //checks if the keyboard height changes with emoji keyboard etc.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //updates the infoList by filtering main messageList in Sharing Manager
    private func updateMessageList() {
        if chatType == .Public {
            if let list = SharingManager.sharedInstance.messageDict["public"] {
                messageList = list
                print(list.count)
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
    
    func keyboardWillChangeFrame(notification: NSNotification) {
        if let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardFrame.size.height
            
            //update constraint in relation to new keyboard height
            constraintHandler.getConstraint(object: "textView", type: "bottomUp").isActive = false
            constraintHandler.addConstraint(object: "textView", type: "bottomUp", constraint: textView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -(keyboardHeight + 10)))
            constraintHandler.getConstraint(object: "textView", type: "bottomUp").isActive = true
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        shiftViewUp(true)
        expandTextView(true)
        sendButton.isHidden = false
        attachmentButton.isHidden = false
        UIView.animate(withDuration: 1.0) {self.view.layoutIfNeeded()}
        scrollToLatest()
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        shiftViewUp(false)
        expandTextView(false)
        sendButton.isHidden = true
        attachmentButton.isHidden = true
        UIView.animate(withDuration: 1.0) {self.view.layoutIfNeeded()}
        tableView.reloadData()
    }
    
    func shiftViewUp(_ indicator: Bool) {
        //must not enable height constraint here
        constraintHandler.getConstraint(object: "textView", type: "bottomDown").isActive = !indicator
        constraintHandler.getConstraint(object: "textView", type: "bottomUp").isActive = indicator
    }
    
    func expandTextView(_ indicator: Bool) {
        constraintHandler.getConstraint(object: "textView", type: "height").isActive = !indicator
        constraintHandler.getConstraint(object: "textView", type: "leftShrink").isActive = !indicator
        constraintHandler.getConstraint(object: "textView", type: "leftExpand").isActive = indicator
        constraintHandler.getConstraint(object: "textView", type: "rightShrink").isActive = !indicator
        constraintHandler.getConstraint(object: "textView", type: "rightExpand").isActive = indicator
    }
    
    private func scrollToLatest() {
        if index != nil {
            let length = messageList.count + 1
            if length > 0 {
                index.row = length - 1
                tableView.scrollToRow(at: index, at: UITableViewScrollPosition.top, animated: true)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tempIndex = indexPath.row
        if tempIndex == 0 {
            return 60
        } else if tempIndex == messageList.count + 1{
            return 70
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messageList.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.index = indexPath
        let tempIndex = indexPath.row
        if tempIndex == 0 || tempIndex == messageList.count + 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "spacerCell", for: indexPath)
            return cell
        }
        
        let tempMessage = self.messageList[tempIndex - 1]
        if tempMessage.getSender() == username {
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
}
