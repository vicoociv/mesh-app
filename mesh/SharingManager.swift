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
    var messageDict = [String: [Message]]() //maybe hold sent and unsent messages together
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
    
    func sendMessage(message: Message) {
        let messageToSend = DataProcessor.getMessageToSend(message: message)
        if message.getRecipient() == "public" {
            networkService.sendInformation(messageToSend, directConnections)
        } else {
            networkService.sendInformation(messageToSend, [message.getRecipient()])
        }
    }
    
    func appendMessage(sent: Bool, message: Message) {
        let contact = message.getRecipient()
        if !sent {
            if unsentMessageDict[contact] != nil {
                unsentMessageDict[contact]?.append(message)
            } else {
                unsentMessageDict[contact] = [message]
            }
            message.setSentStatus(false)
        }
        if messageDict[contact] != nil {
            messageDict[contact]?.append(message)
        } else {
            messageDict[contact] = [message]
        }
    }
    
    func addMessage(sent: Bool, username: String, msg: String, contactName: String) {
        let tempID = Int(arc4random_uniform(100000))
        let tempMessage = Message(sent: sent, id: tempID, sender: username, message: msg, recipient: contactName)
        
        if contactName == "public" || directConnections.contains(contactName){
            sendMessage(message: tempMessage)
            appendMessage(sent: true, message: tempMessage)

            if(!sent) {
                meshDatabase.addMessage(type: "unsentMessage", message: tempMessage)
            } else {
                meshDatabase.addMessage(type: "message", message: tempMessage)
            }
        } else if contactList.contains(contactName) {
            meshDatabase.addMessage(type: "message", message: tempMessage)
            appendMessage(sent: false, message: tempMessage)
        } else {
            meshDatabase.addMessage(type: "unsentMessage", message: tempMessage)
            appendMessage(sent: false, message: tempMessage)
        }
    }
    
    func addTag(title: String, description: String, latitude: Double, longitude: Double) {
        let tempID = Int(arc4random_uniform(100000))
        let tempTag = Tag(id: tempID, title: title, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), info: description)
        let tagToSend = DataProcessor.getTagToSend(id: tempID, tag: tempTag)
        networkService.sendInformation(tagToSend, directConnections)
        tagList.append(tempTag)
        meshDatabase.addTag(tag: tempTag)
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
                let tempRecipient = tempMessage.getRecipient()
                
                if  tempRecipient == self.username || tempRecipient == "public"{
                    
                    self.appendMessage(sent: true, message: tempMessage)
                    self.meshDatabase.addMessage(type: "message", message: tempMessage)
                    
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
                    self.meshDatabase.addTag(tag: tempTag)
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
