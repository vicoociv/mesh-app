//
//  SharingManager.swift
//  mesh
//
//  Created by Victor Chien on 12/29/16.
//  Copyright © 2016 Victor Chien. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation


class SharingManager {
    static let sharedInstance = SharingManager()
    var networkService = NetworkServiceManager()
    var meshDatabase = meshDB()
    var messageList = [Message]()
    var tagList = [Tag]()
    
    //update later to be user inputted
    var username = UIDevice.current.name
    
    init() {
        networkService.delegate = self
        messageList = meshDatabase.getMessages()
        tagList = meshDatabase.getTags()
    }
    
    //devices connected to phone
    var directConnections = [String]()
    
    //Needs to be stored via SQLite later
    var contactList = [String]()
    
    //stores all indirectly connected contacts
    var indirectConnections = [String: [String]]()
    
    
    func addMessage(username: String, msg: String, contactName: String) {
        let tempID = Int(arc4random_uniform(100000))
        let messageToSend = DataProcessor.getMessageToSend(id: tempID, sender: username, message: msg, receiver: contactName)
        networkService.sendInformation(messageToSend, directConnections)
        messageList.append(Message(id: tempID, sender: "me", message: msg, recipient: contactName))
        meshDatabase.addMessage(id: tempID, name: "me", message: msg, recipient: contactName)
        meshDatabase.clipMessageList(list: messageList)
    }
    
    func addTag(title: String, description: String, latitude: Double, longitude: Double) {
        let tempID = Int(arc4random_uniform(100000))
        let tagToSend = DataProcessor.getTagToSend(id: tempID, title: title, description: description, latitude: latitude, longitude: longitude)
        networkService.sendInformation(tagToSend, directConnections)
        tagList.append(Tag(id: tempID, title: title, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), info: description))
        meshDatabase.addTag(id: tempID, name: title, specifics: description, long: longitude, lat: latitude)
    }
    
    //maybe run this ina background thread when called!!!
    func addIndirectContacts(contacts: String) {
        var list = DataProcessor.packageContacts(contacts: contacts)
        var count = 0
        for _ in 0 ... list.count/2 {
            let indirectContact = list[count]
            let from = list[count + 1]

            if indirectConnections[indirectContact] == nil {
                indirectConnections[indirectContact] = [from]
            } else {
                if indirectConnections[indirectContact] != nil {
                    indirectConnections[indirectContact]?.append(from)
                }
            }
            count += 2
        }
    }
}

extension SharingManager : NetworkServiceManagerDelegate {
    
    //finds the names of the connected devices
    func connectedDevicesChanged(_ manager: NetworkServiceManager, connectedDevices: [String]) {
        OperationQueue.main.addOperation { () -> Void in
            self.directConnections = connectedDevices
        }
    }
    
    //receiving data and using it
    func updateData(_ manager: NetworkServiceManager, dataString: String) {
        OperationQueue.main.addOperation { () -> Void in
            let type = DataProcessor.checkDataType(data: dataString)
            let tempConnected = SharingManager.sharedInstance.directConnections
            
            if type == "message" {
                let tempMessage = DataProcessor.decomposeMessage(message: dataString)
                
                //if already have message then will not store it
                if !(DataProcessor.checkMessagesEquality(message: tempMessage, messageList: self.messageList)) {
                    if tempMessage.getRecipient() == self.username || tempMessage.getRecipient() == "public"{
                        
                        self.messageList.append(tempMessage)
                        self.meshDatabase.addMessage(id: tempMessage.getID(), name: tempMessage.getSender(), message: tempMessage.getMessage(), recipient: tempMessage.getRecipient())
                        self.meshDatabase.clipMessageList(list: self.messageList)
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MessageNotification"), object: nil, userInfo: nil)
                    } else {
                        //propagating message to other phones nearby
                        self.networkService.sendInformation(dataString, tempConnected)
                    }
                }
            } else if type == "tag" {
                let tempTag = DataProcessor.decomposeTag(message: dataString)
                if !(DataProcessor.checkTagsEquality(tag: tempTag, tagList: self.tagList)) {
                    self.meshDatabase.addTag(id: tempTag.getID(), name: tempTag.getTitle(), specifics: tempTag.getDescription(), long: tempTag.getLongitude(), lat: tempTag.getLatitude())
                    self.tagList.append(tempTag)
                } else {
                    //propagating tag to other phones nearby
                    self.networkService.sendInformation(dataString, tempConnected)
                }
            } else {
                NSLog("%@", "No Data Received")
            }
        }
    }
}
