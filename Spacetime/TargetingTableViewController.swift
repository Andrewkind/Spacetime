//
//  TargetingTableViewController.swift
//  Spacetime
//
//  Created by Andrew Kind on 2015-12-26.
//  Copyright © 2015 Andrew Kind. All rights reserved.
//

import UIKit
import SpriteKit

class TargetingTableViewController: UITableViewController {

    var gameScene : GameScene?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell = UITableViewCell()
        
        
        // Configure the cell...
        
        if (indexPath.row == 0) {
            cell = tableView.dequeueReusableCellWithIdentifier("TargetingCell", forIndexPath: indexPath)
            cell.textLabel!.text = "Enemy"
        }
        else if (indexPath.row == 1) {
            cell = tableView.dequeueReusableCellWithIdentifier("TargetingCell", forIndexPath: indexPath)
            cell.textLabel?.text = "Planet"
            
        }
        else if (indexPath.row == 2) {
            cell = tableView.dequeueReusableCellWithIdentifier("CoordinatesCell", forIndexPath: indexPath)
        }
        return cell
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Ships / Planets / Other"
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let delegate = GameScene()
        delegate.setTargetDelegate = self as? SetTargetDelegate
        
        
        if (indexPath.row == 0) {
            
            delegate.SetTarget("enemy")
            // stuff
        }
        else if (indexPath.row == 1) {
            delegate.SetTarget("planet")
        }
        else if (indexPath.row == 2) {
            
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! CoordinatesTableViewCell
            if (cell.xTextField.text != "" && cell.yTextField != "") {
            
                var x : CGFloat = CGFloat()
                var y : CGFloat = CGFloat()
                
                if let n = NSNumberFormatter().numberFromString(cell.xTextField.text!) {
                    x = CGFloat(n)
                }
            
                if let n = NSNumberFormatter().numberFromString(cell.yTextField.text!) {
                    y = CGFloat(n)
                }
                
                let point = CGPointMake(x, y)
                delegate.SetCoordinates(point)

            }
                
            
        }
    
    dismissViewControllerAnimated(true, completion: {})
}


/*
// Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
