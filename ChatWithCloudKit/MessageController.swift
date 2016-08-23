//
//  MessageController.swift
//  ChatWithCloudKit
//
//  Created by Retika Kumar on 8/15/16.
//  Copyright © 2016 kumar.retika. All rights reserved.
//

import Foundation
import CloudKit

let MessagesControllerDidRefreshNotification = "MessagesControllerDidRefreshNotification"



class MessageController {
    var messages: [Message] = []
    
    private (set) var message = [Message]() {
        
        didSet {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                NSNotificationCenter.defaultCenter().postNotificationName(MessagesControllerDidRefreshNotification, object: self)
            })

        }
        
    }
    
    
    static let sharedController = MessageController()
    let cloudKitManager: CloudKitManager
    
    init() {
        self.cloudKitManager = CloudKitManager()
        //
        self.fetchMessage(Message.typeKey) { (error) in
            print("fetch Message")
            
        }
        
        
    }
    
    func createMessage(title: String, text: String, timestamp: NSDate, sender: CKReference, completion: ((Message) -> Void)?) {
        //let timestamp = NSDateFormatterStyle.ShortStyle
        
        let message = Message(title: title, text: text, timestamp: NSDate(), sender: sender)
        messages.append(message)
        cloudKitManager.saveRecord(CKRecord(message)!) { (record, error) in
            guard let record = record else {
                if let error = error {
                    NSLog(" Error saving new message to CloudKit: \(error)")
                    return
                }
                completion?(message)
                return
            }
            
            message.cloudKitRecordID = record.recordID
        }
        
        
    }
    

    func fetchMessage(type: String, completion: (NSError?) -> Void) {
        var predicate: NSPredicate
        predicate = NSPredicate(value: true)

        cloudKitManager.fetchRecordsWithType(type, predicate: predicate, recordFetchedBlock: { (record) in
            if let message = Message(record: record) {
                self.messages.append(message)
            }
            }) { (records, error) in
                if let error = error {
                    NSLog("Error fetching cloudkit record of type: \(error)")
                }
                completion(error)
        }
        
        
    }
    
    
    func saveMessage(message: Message, completion: () -> Void) {
        guard let messageRecord = message.cloudKitRecord else { return }
        cloudKitManager.saveRecord(messageRecord) { (record, error) in
            if error != nil {
                print("Error saving message to cloudKit: \(error?.localizedDescription)")
                completion()
            }
            self.messages.append(message)
            completion()
        }
    }
    
//    private func recordsOfType(type: String) -> [CloudKitSyncable] {
//        switch type {
//        case "User":
//            return messages.flatMap{$0 as CloudKitSyncable}
//        case "Message":
//            return messages.flatMap{$0 as CloudKitSyncable}
//        default:
//            return []
//        }
//        
//    }
}
