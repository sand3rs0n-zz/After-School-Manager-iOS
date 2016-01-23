//
//  SelectChildToAddToRosterViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 1/22/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class SelectStudentToAddToRosterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var studentListTable: UITableView!

    private var forwardedStudentID = ""
    private var students = [PFObject]()
    private var rosterID = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        getStudents()
        // Do any additional setup after loading the view.
    }

    private func getStudents() {
        let query = PFQuery(className: "StudentProfile")
        query.whereKey("username", equalTo: (currentUser?.username)!)
        let subquery = PFQuery(className: "StudentRosters")
        subquery.whereKey("rosterID", equalTo: rosterID)
        query.whereKey("objectId", doesNotMatchKey: "studentID", inQuery: subquery)
        query.orderByAscending("lastName")
        do {
            students = try query.findObjects()
        } catch {
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setRosterID(rosterID: String) {
        self.rosterID = rosterID
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let student: PFObject = students[indexPath.row]
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = (student["firstName"] as? String)! + " " + (student["lastName"] as? String)!
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let student: PFObject = students[(indexPath.row)]
        forwardedStudentID = student.objectId!
        performSegueWithIdentifier("SelectStudentToAddToRoster", sender: self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "SelectStudentToAddToRoster") {
        let aeavc = segue.destinationViewController as? AddOrEditAttendanceViewController
        aeavc?.setState(1)
        aeavc?.setTitleValue("Add Student to Roster")
        aeavc?.setStudentId(forwardedStudentID)
        aeavc?.setRosterId(rosterID)
        aeavc?.setButtonText("Add Attendance")
        }
    }

    @IBAction func returnToSelectStudentToAddToRosterUnwind(segue: UIStoryboardSegue) {
        getStudents()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
        self.studentListTable.reloadData()
        })
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
