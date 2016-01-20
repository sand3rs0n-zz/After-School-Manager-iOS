//
//  RosterViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 1/19/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class RosterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var titleBar: UINavigationItem!
    
    private var navTitle = ""
    private var rosterID = ""
    private var students = [PFObject]()
    private var roster = [PFObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleBar.title = navTitle

        let query = PFQuery(className: "StudentRosters")
        query.whereKey("rosterID", equalTo: rosterID)
        do {
            students = try query.findObjects()
        } catch {
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setTitleValue(navTitle: String) {
        self.navTitle = navTitle
    }
    
    func setRosterID(rosterID: String) {
        self.rosterID = rosterID
    }

    func setRoster(roster: [PFObject]) {
        self.roster = roster
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let student: PFObject = students[indexPath.row]
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = (student["studentFirstName"] as? String)! + " " + (student["studentLastName"] as? String)!
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let student: PFObject = students[(indexPath.row)]
    }

    @IBAction func returnToRosterUnwind(segue: UIStoryboardSegue) {
        //getStudents()
        /*dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.rosterListTable.reloadData()
        })*/
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "RosterToEditRoster") {
            let crvc = segue.destinationViewController as? CreateRosterViewController
            crvc?.setState(1)
            crvc?.setTitleValue("Edit Roster")
            crvc?.setExistingRoster(roster)
            crvc?.setCreateRosterButtonValue("Edit Roster")
        }
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
