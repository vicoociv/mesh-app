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
    
    //update later to be user inputted
    var username = UIDevice.current.name
    
    //information to be moved around
    var messageDict = [String: [Message]]()
    var unsentMessageDict = [String: [Message]]()
    var tagList = [Tag]()
    
    var directConnections = [String]()
    var indirectConnections = [String: [String]]()
    var contactList = [String]()
    
    init() {
        networkService.delegate = self
        messageDict = meshDatabase.getDeliveredMessages()
        unsentMessageDict = meshDatabase.getUnsentMessages()
        tagList = meshDatabase.getTags()
        generateContacts()
    }
    
    private func generateContacts() {
        for i in 0...20 {
            contactList.append("Victor Chien \(i)")
        }
    }
    
    func sendMessage(id: Int, username: String, msg: String, contactName: String) {
        let messageToSend = DataProcessor.getMessageToSend(id: id, sender: username, message: msg, receiver: contactName)
        if contactName == "public" {
            networkService.sendInformation(messageToSend, directConnections)
        } else {
            networkService.sendInformation(messageToSend, [contactName])
            print("Step 4")
        }
    }
    
    func appendMessage(sent: Bool, contact: String, message: Message) {
        if sent {
            if unsentMessageDict[contact] != nil {
                unsentMessageDict[contact]?.append(message)
            } else {
                unsentMessageDict[contact] = [message]
            }
        } else {
            if messageDict[contact] != nil {
                messageDict[contact]?.append(message)
            } else {
                messageDict[contact] = [message]
            }
        }
    }
    
    func addMessage(unsent: Bool, username: String, msg: String, contactName: String) {
        let tempID = Int(arc4random_uniform(100000))
        let tempMessage = Message(id: tempID, sender: "me", message: msg, recipient: contactName)
        
        print("Step 2 + \(directConnections)")

        //CHECK HERE!!!!!! - Never reached below
        //must also check if in indirect connections later
        if contactName == "public" || directConnections.contains(contactName){
            sendMessage(id: tempID, username: username, msg: msg, contactName: contactName)
            if(!unsent) {
                meshDatabase.addMessage(type: "message", id: tempID, name: "me", message: msg, recipient: contactName)
            }
        } else if contactList.contains(contactName) {
            meshDatabase.addMessage(type: "unsentMessage", id: tempID, name: "me", message: msg, recipient: contactName)
            appendMessage(sent: true, contact: contactName, message: tempMessage)
        }
        appendMessage(sent: false, contact: contactName, message: tempMessage)
    }
    
    func addTag(title: String, description: String, latitude: Double, longitude: Double) {
        let tempID = Int(arc4random_uniform(100000))
        let tagToSend = DataProcessor.getTagToSend(id: tempID, title: title, description: description, latitude: latitude, longitude: longitude)
        networkService.sendInformation(tagToSend, directConnections)
        tagList.append(Tag(id: tempID, title: title, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), info: description))
        meshDatabase.addTag(id: tempID, name: title, specifics: description, long: longitude, lat: latitude)
    }

    
//NETWORK STUFF
    //maybe run this in a background thread when called!!!
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
    
    //to be used by the network class
    func addDirectConnection(name: String) {
        directConnections.append(name)
    }
    
    func removeDirectConnection(name: String) {
        var i = 0
        for element in directConnections {
            if element == name {
                directConnections.remove(at: i)
            }
            i += 1
        }
    }
    
    
//getter functions
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
    
    func getMessageDict() -> [String: [Message]] {
        return messageDict
    }
    
    func getUnsentMessageDict() -> [String: [Message]] {
        return unsentMessageDict
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

extension SharingManager : NetworkServiceManagerDelegate {

    func connectedDevicesChanged(_ manager: NetworkServiceManager, connectedDevices: [String]) {
        OperationQueue.main.addOperation { () -> Void in
            self.directConnections = connectedDevices
        }
    }
    
    //receiving data and using it
    func updateData(_ manager: NetworkServiceManager, dataString: String) {
        OperationQueue.main.addOperation { () -> Void in
            let type = DataProcessor.checkDataType(data: dataString)
            
            if type == "message" {
                let tempMessage = DataProcessor.decomposeMessage(message: dataString)
                let tempSender = tempMessage.getSender()
                let tempRecipient = tempMessage.getRecipient()
                if  tempRecipient == self.username || tempRecipient == "public"{
                    
                    self.appendMessage(sent: false, contact: tempSender, message: tempMessage)
                    
                    self.meshDatabase.addMessage(type: "message", id: tempMessage.getID(), name: tempMessage.getSender(), message: tempMessage.getMessage(), recipient: tempMessage.getRecipient())
                    
                    //Notifies view controller of new message
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MessageNotification"), object: nil, userInfo: nil)
                } else {
                    //propagating message to other phones nearby
                    //self.networkService.sendInformation(dataString, tempConnected)
                }
            } else if type == "tag" {
                let tempTag = DataProcessor.decomposeTag(message: dataString)
                
                //prevents duplicates. Will have to optimize later maybe
                if !(DataProcessor.checkTagsEquality(tag: tempTag, tagList: self.tagList)) {
                    self.meshDatabase.addTag(id: tempTag.getID(), name: tempTag.getTitle(), specifics: tempTag.getDescription(), long: tempTag.getLongitude(), lat: tempTag.getLatitude())
                    self.tagList.append(tempTag)
                } else {
                    //propagating tag to other phones nearby
                    //self.networkService.sendInformation(dataString, tempConnected)
                }
            } else {
                NSLog("%@", "No Data Received")
            }
        }
    }
}
