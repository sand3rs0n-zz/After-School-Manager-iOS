//
//  AddOrEditAttendanceViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 1/22/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class AddOrEditAttendanceViewController: UIViewController {

    private var state = 0

    @IBOutlet weak var monday: UIButton!
    @IBOutlet weak var tuesday: UIButton!
    @IBOutlet weak var wednesday: UIButton!
    @IBOutlet weak var thursday: UIButton!
    @IBOutlet weak var friday: UIButton!
    @IBOutlet weak var saturday: UIButton!
    @IBOutlet weak var sunday: UIButton!

    @IBOutlet weak var deleteFromRosterButton: UIButton!
    @IBOutlet weak var updateAttendanceButton: UIButton!
    @IBOutlet weak var titleBar: UINavigationItem!
    @IBOutlet weak var studentName: UILabel!

    private var week: [UIButton] = []
    private var weekBool = [false, false, false, false, false, false, false]
    private var navTitle = ""
    private var studentID = ""
    private var rosterID = ""
    private var schedules = [PFObject]()
    private var students = [PFObject]()
    private var buttonText = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        week = [monday, tuesday, wednesday, thursday, friday, saturday, sunday]

        self.titleBar.title = navTitle
        self.updateAttendanceButton!.setTitle(buttonText, forState: .Normal)

        if (state == 0) {
            fillEditPage()
        } else if (state == 1) {
            fillAddPage()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func fillAddPage() {
        let query = PFQuery(className: "StudentProfile")
        query.whereKey("objectId", equalTo: studentID)
        do {
            students = try query.findObjects()
        } catch {
        }
        let student = students[0]
        studentName.text = (student["firstName"] as? String)! + " " + (student["lastName"] as? String)!

        deleteFromRosterButton.hidden = true
    }

    private func fillEditPage() {
        let query = PFQuery(className: "StudentRosters")
        query.whereKey("studentID", equalTo: studentID)
        query.whereKey("rosterID", equalTo: rosterID)
        do {
            schedules = try query.findObjects()
        } catch {
        }

        let schedule = schedules[0]
        studentName.text = (schedule["studentFirstName"] as? String)! + " " + (schedule["studentLastName"] as? String)!

        if (schedule["monday"] as? Bool == true) {
            monday.backgroundColor = UIColor.greenColor()
            weekBool[0] = true
        }
        if (schedule["tuesday"] as? Bool == true) {
            tuesday.backgroundColor = UIColor.greenColor()
            weekBool[1] = true
        }
        if (schedule["wednesday"] as? Bool == true) {
            wednesday.backgroundColor = UIColor.greenColor()
            weekBool[2] = true
        }
        if (schedule["thursday"] as? Bool == true) {
            thursday.backgroundColor = UIColor.greenColor()
            weekBool[3] = true
        }
        if (schedule["friday"] as? Bool == true) {
            friday.backgroundColor = UIColor.greenColor()
            weekBool[4] = true
        }
        if (schedule["saturday"] as? Bool == true) {
            saturday.backgroundColor = UIColor.greenColor()
            weekBool[5] = true
        }
        if (schedule["sunday"] as? Bool == true) {
            sunday.backgroundColor = UIColor.greenColor()
            weekBool[6] = true
        }
    }

    func setState(state: Int) {
        self.state = state
    }

    func setTitleValue(navTitle: String) {
        self.navTitle = navTitle
    }

    func setButtonText(buttonText: String) {
        self.buttonText = buttonText
    }

    func setStudentId(studentID: String) {
        self.studentID = studentID
    }

    func setRosterId(rosterID: String) {
        self.rosterID = rosterID
    }

    @IBAction func backButton(sender: AnyObject) {
        back()
    }

    private func back() {
        if (state == 0) {
            performSegueWithIdentifier("EditStudentFromAllRostersUnwind", sender: self)
        } else if (state == 1) {
            performSegueWithIdentifier("ReturnToSelectStudentToAddToRosterUnwind", sender: self)
        }
    }

    @IBAction func mondaySelect(sender: AnyObject) {
        daySelected(0)
    }
    @IBAction func tuesdaySelect(sender: AnyObject) {
        daySelected(1)
    }
    @IBAction func wednesdaySelect(sender: AnyObject) {
        daySelected(2)
    }
    @IBAction func thursdaySelect(sender: AnyObject) {
        daySelected(3)
    }
    @IBAction func fridaySelect(sender: AnyObject) {
        daySelected(4)
    }
    @IBAction func saturdaySelect(sender: AnyObject) {
        daySelected(5)
    }
    @IBAction func sundaySelect(sender: AnyObject) {
        daySelected(6)
    }

    private func daySelected(day: Int) {
        if (weekBool[day] == true) {
            weekBool[day] = false
        } else {
            weekBool[day] = true
        }
        let dayOfWeek = week[day]
        if (dayOfWeek.backgroundColor == UIColor.greenColor()) {
            dayOfWeek.backgroundColor = UIColor.grayColor()
        } else {
            dayOfWeek.backgroundColor = UIColor.greenColor()
        }
    }

    @IBAction func updateAttendance(sender: AnyObject) {
        //save/update selecetd student
        //loop through week to find which ones are "selected"
        if (state == 0) {
            saveAttendance(schedules[0])
        } else if (state == 1) {
            let attendance = PFObject(className: "StudentRosters")
            saveAttendance(attendance)
        }
    }

    private func saveAttendance(attendance: PFObject) {
        var name = studentName.text?.componentsSeparatedByString(" ")
        attendance["studentFirstName"] = name![0]
        attendance["studentLastName"] = name![1]
        attendance["monday"] = weekBool[0]
        attendance["tuesday"] = weekBool[1]
        attendance["wednesday"] = weekBool[2]
        attendance["thursday"] = weekBool[3]
        attendance["friday"] = weekBool[4]
        attendance["saturday"] = weekBool[5]
        attendance["sunday"] = weekBool[6]
        attendance["studentID"] = studentID
        attendance["rosterID"] = rosterID
        attendance["username"] = currentUser?.username!

        attendance.saveInBackgroundWithBlock {
            (success: Bool, error:NSError?) -> Void in
            if(success) {
                print("Saved")
                self.back()
            }
            else {
                print("Error")
            }
        }
    }

    @IBAction func deleteFromRoster(sender: AnyObject) {
        let myAlertController = UIAlertController(title: "Remove Student from Roster", message: "Are you sure you want to remove the student from this roster?", preferredStyle: .Alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Do some stuff
        }
        myAlertController.addAction(cancelAction)

        let nextAction = UIAlertAction(title: "Delete", style: .Default) { action -> Void in
            self.schedules[0].deleteInBackgroundWithBlock {
                (success: Bool, error:NSError?) -> Void in
                if(success) {
                    print("Deleted")
                    self.back()
                }
                else {
                    print("Error")
                }
            }
        }
        myAlertController.addAction(nextAction)
        presentViewController(myAlertController, animated: true, completion: nil)
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
