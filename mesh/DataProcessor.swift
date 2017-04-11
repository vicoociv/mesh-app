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

        return Message(id: tempID!, sender: tempSender, message: tempMessage, recipient: tempReceiver)
    }
    
    static func getMessageToSend(id: Int, sender: String, message: String, receiver: String) -> String {
        return "message\(separator)\(id)\(separator)\(sender)\(separator)\(message)\(separator)\(receiver)"
    }

    static func filterMessages(sender: String, recipient: String, messageList: [Message]) -> [String] {
        var resultList = [String]()
        for message in messageList {
            if message.getSender() == sender && message.getRecipient() == recipient || message.getSender() == "me" && message.getRecipient() == sender{
                resultList.append("\(message.getSender()):  \(message.getMessage())")
            }
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
    
    //makes Tag object
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
    
    static func getTagToSend(id: Int, title: String, description: String, latitude: Double, longitude: Double) -> String {
        return "tag\(separator)\(id)\(separator)\(title)\(separator)\(description)\(separator)\(latitude)\(separator)\(longitude)"
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
