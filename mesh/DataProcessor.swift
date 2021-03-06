//
//  DataProcessor.swift
//  mesh
//
//  Created by Victor Chien on 1/20/17.
//  Copyright © 2017 Victor Chien. All rights reserved.
//

import Foundation
import CoreLocation


class DataProcessor {
    
    static let separator = "&#$"
    
//MESSAGES
    //checks if messsage or coordinate
    static func checkDataType(data: String) -> String {
        var list = data.components(separatedBy: separator)
        return list[0]
    }
    
    //makes Message object
    static func decomposeMessage(message: String) -> Message {
        var list = message.components(separatedBy: separator)
        let tempID = Int(list[1])
        let tempSender = list[2]
        let tempMessage = list[3]
        let tempReceiver = list[4]

        return Message(sent: true, id: tempID!, sender: tempSender, message: tempMessage, recipient: tempReceiver)
    }
    
    static func getMessageToSend(message: Message) -> String {
        return "message\(separator)\(message.getID())\(separator)\(message.getSender())\(separator)\(message.getMessage())\(separator)\(message.getRecipient())"
    }

    static func filterMessages(contact: String, messageDict: [String: [Message]]) -> [String] {
        var messageList: [Message] = []
        var resultList: [String] = []

        if let list = messageDict[contact] {
            messageList = list
        }
        
        for message in messageList {
            resultList.append("\(message.getSender()):  \(message.getMessage())")
        }
        return resultList
    }
    
    static func checkMessagesEquality(message: Message, messageList: [Message]) -> Bool {
        for msg in messageList {
            if message.checkEquals(message2: msg) {
                return true
            }
        }
        return false
    }
    

//Tags
    static func decomposeTag(message: String) -> Tag {
        var list = message.components(separatedBy: separator)
        let tempID = Int(list[1])
        let tempTitle = list[2]
        let tempDescription = list[3]
        let tempLatitude = Double(list[4])
        let tempLongitude = Double(list[5])
        
        //possible point of failure
        return Tag(id: tempID!, title: tempTitle, coordinate: CLLocationCoordinate2D(latitude: tempLatitude!, longitude: tempLongitude!), info: tempDescription)
    }
    
    static func getTagToSend(id: Int, tag: Tag) -> String {
        return "tag\(separator)\(tag.getID())\(separator)\(tag.getTitle())\(separator)\(tag.getDescription())\(separator)\(tag.getLatitude())\(separator)\(tag.getLongitude())"
    }
    
    static func checkTagsEquality(tag: Tag, tagList: [Tag]) -> Bool {
        for t in tagList {
            if tag.checkEquals(tag: t) {
                return true
            }
        }
        return false
    }
    

//Indirect Contact Adding
    static func packageContacts(contacts: [String], name: String) -> String{
        var result = "contacts\(separator)"
        
        for item in contacts {
            result += "\(item)\(separator)\(name)"
        }
        return result
    }
    
    static func packageContacts(contacts: String) -> [String]{
        var list = contacts.components(separatedBy: separator)
        list.remove(at: 0)
        return list
    }

    
}
