//
//  meshDB.swift
//  mesh
//
//  Created by Victor Chien on 1/12/17.
//  Copyright © 2017 Victor Chien. All rights reserved.
//

import Foundation
import SQLite
import CoreLocation
import UIKit

class meshDB {
    static let instance = meshDB()
    private let db: Connection?
    
    private let info = Table("info")
    private let intID = Expression<Int?>("id")
    
    //can be: "message" "coordinate" "contact" "system"
    private let dataType = Expression<String>("dataType")
    
    private let title = Expression<String?>("title")
    private let detail = Expression<String?>("detail")
    
    //can be: "public" "other person's name" "own name"
    private let receiver = Expression<String?>("receiver")
    
    private let longitude = Expression<Double?>("longitude")
    private let latitude = Expression<Double?>("latitude")


    init() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        do {
            db = try Connection("\(path)/mesh.sqlite3")
        } catch {
            db = nil
            print ("Unable to open database")
        }
        
        createTable()
    }
    
    private func createTable() {
        do {
            try db!.run(info.create(ifNotExists: true) { table in
                table.column(intID)
                table.column(dataType)
                table.column(title)
                table.column(detail)
                table.column(receiver)
                table.column(longitude)
                table.column(latitude)
            })
        } catch {
            print("Unable to create table")
        }
    }
    
    func addMessage(type: String, message: Message) {
        do {
            let insert = info.insert(dataType <- type, intID <- message.getID(), title <- message.getSender(), detail <- message.getMessage(), receiver <- message.getRecipient(), longitude <- nil, latitude <- nil)
            _ = try db!.run(insert)
        } catch {
            print("Insert failed")
        }
    }
    
    //returns dict of all Messages under contact names
    private func getMessages(type: String) -> [String: [Message]] {
        var messageDict = [String: [Message]]()
        do {
            for info in try db!.prepare(self.info) {
                if info[dataType] == type {
                    if let tempID = info[intID], let tempSender = info[title], let tempReciever = info[receiver], let tempMessage = info[detail] {
                        var sentStatus = true
                        if type == "unsentMessage" {
                            sentStatus = false
                        }
                        
                        let tempMessage = Message(sent: sentStatus, id: tempID, sender: tempSender, message: tempMessage, recipient: tempReciever)
                        
                        var key = ""
                        let tempUsername = UIDevice.current.name
                        if tempSender == tempUsername {
                            key = tempReciever
                        } else if tempReciever == tempUsername {
                            key = tempSender
                        } else {
                            key = "public"
                        }
                        
                        if messageDict[key] == nil {
                            messageDict[key] = [tempMessage]
                        } else {
                            messageDict[key]?.append(tempMessage)
                        }
                    }
                }
            }
        } catch {
            print("Select failed")
        }
        return messageDict
    }
    
    func getUnsentMessages() -> [String: [Message]] {
        return getMessages(type: "unsentMessage")
    }
    
    func getDeliveredMessages() -> [String: [Message]] {
        return getMessages(type: "message")
    }

    func addTag(tag: Tag) {
        do {
            let insert = info.insert(dataType <- "tag", intID <- tag.getID(), title <- tag.getTitle(), detail <- tag.getDescription(), receiver <- nil, longitude <- tag.getLongitude(), latitude <- tag.getLatitude())
            _ = try db!.run(insert)
        } catch {
            print("Insert failed")
        }
    }
    
    //returns array of all Tag Objects
    func getTags() -> [Tag] {
        var tagList = [Tag]()
        do {
            for info in try db!.prepare(self.info) {
                if info[dataType] == "tag" {
                    if let tempID = info[intID], let tempTitle = info[title], let tempInfo = info[detail], let tempLatitude = info[latitude], let tempLogitude = info[longitude] {
                        tagList.append(Tag(id: tempID, title: tempTitle, coordinate: CLLocationCoordinate2D(latitude: tempLatitude, longitude: tempLogitude), info: tempInfo))
                    }
                }
            }
        } catch {
            print("Select failed")
        }
        return tagList
    }
    
    //delete function
    func delete(toDelete: String) {
        do {
            let data = info.filter(dataType == toDelete)
            try db!.run(data.delete())
        } catch {
            print("Delete failed")
        }
    }
    
    func deleteMessage(msgToDelete: Message) {
        do {
            let data = info.filter(intID == msgToDelete.getID() && detail == msgToDelete.getMessage())
            try db!.run(data.delete())
        } catch {
            print("Delete failed")
        }
    }
    
    //limit of 10000 messages stored on phones. Also depends on number of contacts you have. The more contacts you have the less messages you can store per contact. Call this when exiting the app. 
    func clipMessageList(dict: [String: [Message]], numContacts: Int) {
        let max = 20000
        if dict.count > max {
            for (_, list) in dict {
                let overCount = list.count - max/numContacts
                if overCount > 0 {
                    for i in 0...overCount {
                        let tempMessage = list[i]
                        do {
                            let data = info.filter(intID == tempMessage.getID() && detail == tempMessage.getMessage())
                            try db!.run(data.delete())
                        } catch {
                            print("Delete failed")
                        }
                    }
                }
            }
        }
    }
}
