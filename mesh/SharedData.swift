//
//  SharedData.swift
//  mesh
//
//  Created by Victor Chien on 4/21/17.
//  Copyright © 2017 Victor Chien. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class SharedData {
    static let sharedInstance = SharedData()
    var meshDatabase = meshDB()
    
    //update later to be user inputted
    var username = UIDevice.current.name
    
    //information to be moved around
    var messageDict = [String: [Message]]()
    var unsentMessageDict = [String: [Message]]()
    var tagList = [Tag]()
    
    init() {
        messageDict = meshDatabase.getDeliveredMessages()
        unsentMessageDict = meshDatabase.getUnsentMessages()
        tagList = meshDatabase.getTags()
    }
    
    //devices connected to phone
    var directConnections = [String]()
    
    //stores all indirectly connected contacts
    var indirectConnections = [String: [String]]()
    
    //Needs to be stored via SQLite later
    var contactList = [String]()
    
    
    func getUsername() -> String {
        return username
    }
    
    func getdirectConnections() -> [String] {
        return directConnections
    }
    
    func getContactList() -> [String] {
        return contactList
    }
    
    func getTagList() -> [Tag] {
        return tagList
    }
    
    func getMessageList(name: String) -> [Message] {
        let emptyArray = [Message]()
        
        if let list = messageDict[name] {
            return list
        } else {
            return emptyArray
        }
    }
    
    

}
