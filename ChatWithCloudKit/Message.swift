//
//  Message.swift
//  ChatWithCloudKit
//
//  Created by Retika Kumar on 8/15/16.
//  Copyright © 2016 kumar.retika. All rights reserved.
//

import Foundation
import CloudKit

class Message: CloudKitSyncable {
    
    static let typeKey = "Message"
    static let titleKey = "title"
    static let textKey = "text"
    static let timestampKey = "timestamp"
    static let senderKey = "sender"
    
    var title: String
    var text: String
    var timestamp: NSDate
    var sender: CKReference
    
    init(title: String, text: String, timestamp: NSDate = NSDate(), sender: CKReference) {
        self.title = title
        self.text = text
        self.timestamp = timestamp
        self.sender = sender
    }
    
    
    convenience required init?(record: CKRecord) {
        guard let timestamp = record.creationDate,
            let text = record[Message.textKey] as? String,
            let title = record[Message.titleKey] as? String,
            let sender = record[Message.senderKey] as? CKReference else {return nil }
        
        
        self.init(title: title, text: text, timestamp:timestamp, sender: sender)
        cloudKitRecordID = record.recordID
        
    }
    
    var cloudKitRecordID: CKRecordID?
    var recordType: String {return Message.typeKey}
    var cloudKitRecord: CKRecord?
    
    
}

extension CKRecord {
    
    convenience init? (_ message: Message) {
        
        
        //        guard let sender = message.sender else {  fatalError("message does not have sender")  }
        //        let senderRecordID = sender.cloudKitRecordID ?? CKRecord(sender).recordID
        
        let recordID = CKRecordID(recordName: NSUUID().UUIDString)
        self.init(recordType: message.recordType, recordID: recordID)
        
        self[Message.timestampKey] = message.timestamp
        self[Message.titleKey] = message.title
        self[Message.textKey] = message.text
        self[Message.senderKey] = message.sender
    }
}
