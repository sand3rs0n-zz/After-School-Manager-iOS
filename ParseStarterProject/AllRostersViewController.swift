//
//  AllRostersViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 12/17/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class AllRostersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var rosterListTable: UITableView!
    private var rosterList = [PFObject]()

    private var forwardedRosterID = ""
    private var forwardedRosterName = ""
    private var forwardedRoster = [PFObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getRosters()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func getRosters() {
        let query = PFQuery(className: "Rosters")
        query.whereKey("username", equalTo: (currentUser?.username)!)
        do {
            rosterList = try query.findObjects()
        } catch {
        }
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
        forwardedRosterID = roster.objectId!
        forwardedRosterName = roster["name"] as! String
        forwardedRoster = [PFObject](arrayLiteral: roster)
        performSegueWithIdentifier("AllRostersToSpecificRoster", sender: self)
    }

    @IBAction func returnToAllRostersUnwind(segue: UIStoryboardSegue) {
        getRosters()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.rosterListTable.reloadData()
        })
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "AllRostersToSpecificRoster") {
            let rvc = segue.destinationViewController as? RosterViewController
            rvc?.setTitleValue(forwardedRosterName)
            rvc?.setRosterID(forwardedRosterID)
            rvc?.setRoster(forwardedRoster)
        } else if (segue.identifier == "AllRostersToNewRoster") {
            let crvc = segue.destinationViewController as? CreateRosterViewController
            crvc?.setState(0)
            crvc?.setTitleValue("Create Roster")
            crvc?.setCreateRosterButtonValue("Create Roster")
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
