//
//  Message.swift
//  mesh
//
//  Created by Victor Chien on 1/12/17.
//  Copyright © 2017 Victor Chien. All rights reserved.
//

import Foundation


//need one more maps as well -_- maybe nickname too...

class Message {
    private var sender: String!
    private var message: String!
    private var recipient: String!
    private var intID: Int!
    private var sent: Bool!
    
    init(sent: Bool, id: Int, sender: String, message: String, recipient: String) {
        self.sent = sent
        self.intID = id
        self.sender = sender
        self.message = message
        self.recipient = recipient
    }
   
    func getSentStatus() -> Bool {
        return sent
    }
    
    func setSentStatus(_ indicator: Bool) {
        sent = indicator
    }
    
    func getID() -> Int {
        return intID
    }
    
    func getMessage() -> String {
        return message
    }
    
    func getSender() -> String {
        return sender
    }
    
    func getRecipient() -> String {
        return recipient
    }
    
    func checkEquals(message2: Message) -> Bool {
        if intID == message2.getID() && sender == message2.getSender() && recipient == message2.getRecipient() && message == message2.getMessage() {
            return true
        } else {
            return false
        }
    }
}
