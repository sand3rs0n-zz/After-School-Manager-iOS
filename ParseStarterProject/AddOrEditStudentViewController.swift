//
//  AddOrEditStudentViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 1/18/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class AddOrEditStudentViewController: UIViewController {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var birthdayPicker: UIDatePicker!
    @IBOutlet weak var school: UITextField!
    @IBOutlet weak var addUpdateButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!

    @IBOutlet weak var titleBar: UINavigationItem!
    @IBOutlet weak var active: UISegmentedControl!

    private var updateStudent = false
    private var studentID = ""
    private var students = [PFObject]()
    private var guardians = [PFObject]()
    private var contactNumbers = [PFObject]()
    private var navTitle = ""
    private var buttonText = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleBar.title = navTitle
        self.addUpdateButton!.setTitle(buttonText, forState: .Normal)
        if (updateStudent) {
            let studentQuery = PFQuery(className: "StudentProfile")
            let guardianQuery = PFQuery(className: "Guardians")
            let contactQuery = PFQuery(className: "ContactNumbers")

            studentQuery.whereKey("objectId", equalTo: studentID)
            guardianQuery.whereKey("studentID", equalTo: studentID)
            contactQuery.whereKey("studentID", equalTo: studentID)
            do {
                students = try studentQuery.findObjects()
                guardians = try guardianQuery.findObjects()
                contactNumbers = try contactQuery.findObjects()
            } catch {
            }

            fillFields()
        } else {
            deleteButton.hidden = true
        }
        // Do any additional setup after loading the view.
    }

    private func fillFields() {
        let student = students[0]
        firstName.text = student["firstName"] as? String
        lastName.text = student["lastName"] as? String
        school.text = student["school"] as? String
        setDate(student)
        let activeValue = student["active"] as? Bool
        if (activeValue!) {
            active.selectedSegmentIndex = 0
        } else {
            active.selectedSegmentIndex = 1
        }
    }

    private func setDate(student: PFObject) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = String((student["birthDay"] as? Int)!) + "/" + String((student["birthMonth"] as? Int)!) + "/" + String((student["birthYear"] as? Int)!)
        let convertedStartDate = dateFormatter.dateFromString(dateString)
        birthdayPicker.date = convertedStartDate!
    }

    func setTitleValue(navTitle: String) {
        self.navTitle = navTitle
    }

    func setAddUpdateButtonText(buttonText: String) {
        self.buttonText = buttonText
    }

    func setUpdate(update: Bool) {
        updateStudent = update
    }

    func setStudentID(studentID: String) {
        self.studentID = studentID
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateStudent(sender: AnyObject) {
        if (validatFields()) {
            if (updateStudent) {
                let studentProfile = students[0]
                saveStudent(studentProfile)
            } else {
                let studentProfile = PFObject(className: "StudentProfile")
                saveStudent(studentProfile)
            }
        }
    }

    private func saveStudent(studentProfile: PFObject) {
        studentProfile["username"] = currentUser?.username
        studentProfile["firstName"] = firstName.text
        studentProfile["lastName"] = lastName.text
        studentProfile["school"] = school.text

        if (active.selectedSegmentIndex == 0) {
            studentProfile["active"] = true
        } else if (active.selectedSegmentIndex == 1) {
            studentProfile["active"] = false
        }

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let inputDate = dateFormatter.stringFromDate(birthdayPicker.date)
        let dateArr = inputDate.characters.split{$0 == "/"}.map(String.init)
        studentProfile["birthDay"] = Int(dateArr[1])
        studentProfile["birthMonth"] = Int(dateArr[0])
        studentProfile["birthYear"] = Int(dateArr[2])

        studentProfile.saveInBackgroundWithBlock {
            (success: Bool, error:NSError?) -> Void in
            if(success) {
                print("Saved")
            }
            else {
                print("Error")
            }
        }
    }

    private func validatFields() -> Bool {
        if (firstName.text == "" || lastName.text == "" || school.text == ""){
            return false
        }
        return true
    }

    @IBAction func deleteStudent(sender: AnyObject) {
        let myAlertController = UIAlertController(title: "Delete Student", message: "Are you sure you want to delete the student?", preferredStyle: .Alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Do some stuff
        }
        myAlertController.addAction(cancelAction)

        let nextAction = UIAlertAction(title: "Delete", style: .Default) { action -> Void in
        self.students[0].deleteInBackgroundWithBlock {
            (success: Bool, error:NSError?) -> Void in
            if(success) {
                print("Deleted")
                self.performSegueWithIdentifier("instructorMenuStudentsUnwind", sender: self)
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
