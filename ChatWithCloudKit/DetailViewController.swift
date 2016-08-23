//
//  DetailViewController.swift
//  ChatWithCloudKit
//
//  Created by Retika Kumar on 8/15/16.
//  Copyright © 2016 kumar.retika. All rights reserved.
//

import UIKit
import CloudKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var message: Message? {
        didSet {
            if let message = message {updateWithMessage(message)}
        }
    }
    
    
    @IBOutlet weak var messageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        UserController.sharedController.fetchLoggedInUser()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
    }
    func updateWithMessage(message: Message) {
        message.text = messageTextField.text!
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCellWithIdentifier("detailCell") else { return UITableViewCell() }
        cell.textLabel?.text = messageTextField.text
        return cell
    }
    
    
    @IBAction func saveButtonTapped(sender: UIButton) {
        
        // all the text from the entered textField should populate the listViewControllerCell
        
//       let currentUser = UserController.sharedController.fetchLoggedInUser()
//        let currentUser = 
        
       guard let text = messageTextField.text,
        currentUserRecordID = UserController.sharedController.loggedInUser?.cloudKitRecordID else {
            print("Error: No currentUserRecordID found")
            return
        }
        
        
        let sender = CKReference(recordID: currentUserRecordID, action: .None)
        let message = Message(title: text, text: text, timestamp: NSDate(), sender: sender)
        MessageController.sharedController.saveMessage(message) {
//            MessageController.sharedController.messages.append(message)
            
        }
        }
    }








