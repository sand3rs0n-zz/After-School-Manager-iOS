//
//  AllStudentsViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 12/17/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class AllStudentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var studentListTable: UITableView!

    private var studentList = [PFObject]()
    private var forwardedStudentID = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        getStudents()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func getStudents() {
        let query = PFQuery(className: "StudentProfile")
        query.whereKey("username", equalTo: (currentUser?.username)!)
        do {
            studentList = try query.findObjects()
        } catch {
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let student: PFObject = studentList[indexPath.row]
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = (student["firstName"] as? String)! + " " + (student["lastName"] as? String)!
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentList.count
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let student: PFObject = studentList[(indexPath.row)]
        forwardedStudentID = student.objectId!
        performSegueWithIdentifier("InstructorMenuStudentsToEditStudent", sender: self)
    }

    @IBAction func instructorMenuStudentsUnwind(segue: UIStoryboardSegue) {
        getStudents()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.studentListTable.reloadData()
        })
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let aesvc = segue.destinationViewController as? AddOrEditStudentViewController

        if (segue.identifier == "InstructorMenuStudentsToAddStudent") {
            aesvc?.setTitleValue("Add New Student")
            aesvc?.setAddUpdateButtonText("Add Student")
        } else if (segue.identifier == "InstructorMenuStudentsToEditStudent") {
            aesvc?.setTitleValue("Edit Student")
            aesvc?.setAddUpdateButtonText("Update Student")
            aesvc?.setUpdate(true)
            aesvc?.setStudentID(forwardedStudentID)
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
