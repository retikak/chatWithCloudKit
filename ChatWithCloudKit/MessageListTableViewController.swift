//
//  MessageListTableViewController.swift
//  ChatWithCloudKit
//
//  Created by Retika Kumar on 8/15/16.
//  Copyright © 2016 kumar.retika. All rights reserved.
//

import UIKit
var message: Message?
var user: User?

class MessageListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(messagesChanged(_:)), name: MessagesControllerDidRefreshNotification, object: nil)
        print("observer added")
    }
    
    func messagesChanged(notification: NSNotification) {
        tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source



    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return MessageController.sharedController.messages.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
       guard let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? CustomTableViewCell else { return CustomTableViewCell() }
        let messages = MessageController.sharedController.messages[indexPath.row]
    
        cell.updateWithMessage(messages)
    
        
        
        

        return cell
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toCellDetail" {
            if let destinationVC = segue.destinationViewController as? DetailViewController,
                selectedIndex = self.tableView.indexPathForSelectedRow {
                let messages = MessageController.sharedController.messages
                destinationVC.message = messages[selectedIndex.row]
            }
        }
        
    }


}
