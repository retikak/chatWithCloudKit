//
//  UserController.swift
//  ChatWithCloudKit
//
//  Created by Retika Kumar on 8/15/16.
//  Copyright © 2016 kumar.retika. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

public let UserControllerDidRefreshNotification = "UserControllerDidRefreshNotification"


class UserController {
    
    var currentUserRecordID: CKRecordID?
    var currentUserReference : CKReference?
    
    private(set) var loggedInUser: User? {
        didSet  {
            print( "user set")
        }
    }
    
    
    private (set) var users = [User]() {
        
        didSet {
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let nc = NSNotificationCenter.defaultCenter()
                nc.postNotificationName(UserControllerDidRefreshNotification, object: self)
            })
            
        }
    }
    
    
    static let sharedController = UserController()
    let cloudKitManger: CloudKitManager
    
    
    init() {
        self.cloudKitManger = CloudKitManager()
        
        fetchCurrentUserRecord { (success) in
            print("Current user fetched")
        }

    }
    
    func fetchLoggedInUser(){
        cloudKitManger.fetchLoggedInUserRecord { (record, error) in
            guard let record = record else {
                if error != nil {
                    NSLog("error")
                    return
                }
                return
            }
            
            self.cloudKitManger.fetchUsernameFromRecordID(record.recordID, completion: { (givenName, familyName) in
                let user = User(familyName: familyName ?? "", givenName: givenName ?? "")
                
                print(user)
                self.loggedInUser = user
                print (self.loggedInUser)
                return
            })
            
        }
    }
    
    
    func createUser(familyName: String, givenName: String, completion: ((User) -> Void)?) {
        let user = User(familyName: familyName, givenName: givenName)
        users.append(user)
        cloudKitManger.saveRecord(CKRecord(user)) {(record, error) in
            guard let record = record else {
                if error != nil {
                    NSLog("Error saving user /(error)")
                    return
                }
                completion?(user)
                return
            }
            user.cloudKitRecordID = record.recordID
            print(user.cloudKitRecordID)
        }
    }
    
    
    func fetchAllUsers(type: String, completion: (NSError?) -> Void) {
        var predicate: NSPredicate
        predicate = NSPredicate(value: true)
        
        cloudKitManger.fetchRecordsWithType(type, predicate: predicate, recordFetchedBlock: { (record) in
            if let user = User(record: record) {
                self.users.append(user)
            }
        }) { (records, error) in
            if let error = error {
                NSLog("Error fetching cloudkit record of type: \(error)")
            }
            completion(error)
        }
        
        
    }
    
    func fetchCurrentUserRecord(completion: (success: Bool) -> Void) {
        cloudKitManger.fetchLoggedInUserRecord { (record, error) in
            guard let record = record else { completion(success: false); print("Error: record failed"); return }
            self.currentUserRecordID = record.recordID
            print("My current user record is: \(self.currentUserRecordID)")
            let recordID = record.recordID
            let predicate = NSPredicate(format: "reference == %@", recordID)
            self.cloudKitManger.fetchRecordsWithType(User.typeKey, predicate: predicate, recordFetchedBlock: { (record) in
                self.currentUserRecordID = record.recordID
                guard let currentUserID = self.currentUserRecordID else { print("Error: No currentUserID found"); return }
                let user = User(record: record)
                user?.record = record
                self.currentUserReference = CKReference(recordID: currentUserID, action: .None)
                print("My currentUserReference is: \(self.currentUserReference)")
                }) { (records, error) in
                    if error != nil {
                        print("Error fetching current user record: \(error?.localizedDescription)")
                        completion(success: false)
                    } else if records?.count == 0 {
                        completion(success: false)
                    } else if records?.count > 0 {
                        completion(success: true)
                    }
            }
        }
    }
    
}


   