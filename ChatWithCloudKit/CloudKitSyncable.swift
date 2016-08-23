//
//  CloudKitSyncable.swift
//  ChatWithCloudKit
//
//  Created by Retika Kumar on 8/15/16.
//  Copyright © 2016 kumar.retika. All rights reserved.
//

import Foundation
import CloudKit

protocol CloudKitSyncable {
    init?(record: CKRecord)
    
    var cloudKitRecordID: CKRecordID? {get set}
    var recordType: String {get}
}

extension CloudKitSyncable {
    var isSynced: Bool {
        return cloudKitRecordID != nil
        
    }
    
    var cloudKitReference: CKReference? {
        guard let recordID = cloudKitRecordID else {return nil}
        return CKReference(recordID: recordID, action: .None)
    }
}

