//
//  User.swift
//  ChatWithCloudKit
//
//  Created by Retika Kumar on 8/15/16.
//  Copyright © 2016 kumar.retika. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class User : CloudKitSyncable {
    static let typeKey = "User"
    static let familyNameKey = "familyName"
    static let givenNameKey = "givenName"
    //static let recordReferenceKey = "recordReference"
    
    init(familyName: String, givenName: String) {
        self.familyName = familyName
        self.givenName = givenName
        
        //self.recordReference = recordReference
    }
    
    
    var familyName: String
    var givenName: String
    var record: CKRecord?
    //var recordReference: CKReference
    
    //MARK: CloudKitSyncable
    
    convenience required init?(record: CKRecord) {
        guard let familyName = record[User.familyNameKey] as? String,
        givenName = record[User.givenNameKey] as? String
        
        
        //, let recordRefernce = record[User.recordReferenceKey] as? CKReference

            else {return nil}
        self.init(familyName: familyName, givenName: givenName)
        cloudKitRecordID = record.recordID
    }
    
    var recordType: String {return User.typeKey}
    var cloudKitRecordID: CKRecordID?
}

extension CKRecord {
    convenience init(_ user: User) {
        let recordID = CKRecordID(recordName: NSUUID().UUIDString)
        self.init(recordType: user.recordType, recordID:  recordID)
        self[User.familyNameKey] = user.familyName
        self[User.givenNameKey] = user.givenName
        print("user created")
    }
    
    
}

