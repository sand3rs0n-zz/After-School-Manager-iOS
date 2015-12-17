//
//  RosterListViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 12/12/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class RosterListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var rosterState = 0
    private var rosterList = [PFObject]()
    private var rosterType = 0
    @IBOutlet weak var titleBar: UINavigationItem!
    private var navTitle = ""
    
    private var forwardedRosterID = ""
    private var forwardedRosterName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleBar.title = navTitle
        let query = PFQuery(className: "Rosters")
        query.whereKey("username", equalTo: (currentUser?.username)!)
        query.whereKey("rosterType", equalTo: rosterType)
        do {
            rosterList = try query.findObjects()
        } catch {
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setState(state: Int) {
        rosterState = state
    }
    
    func setTitleValue(title: String) {
        navTitle = title
    }
    
    func setRosterType(type: Int) {
        rosterType = type
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let roster: PFObject = rosterList[indexPath.row]
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = roster["name"] as? String
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rosterList.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let roster: PFObject = rosterList[(indexPath.row)]
        forwardedRosterName = roster["name"] as! String
        forwardedRosterID = roster.objectId!
        performSegueWithIdentifier("RosterSelectToStudentRoster", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let srvc = segue.destinationViewController as? StudentRosterViewController
        srvc?.setState(rosterState)
        srvc?.setRosterID(forwardedRosterID)
        srvc?.setTitleValue(forwardedRosterName)
        srvc?.setRosterType(rosterType)
    }

    @IBAction func rosterSelectUnwind(segue: UIStoryboardSegue) {
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
