//
//  StudentInfoViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 12/12/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class StudentInfoViewController: UIViewController {
    
    private var studentID = ""
    private var students = [PFObject]()
    private var guardians = [PFObject]()
    private var contactNumbers = [PFObject]()
    private var dob = Date()
    
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var studentDOB: UILabel!
    @IBOutlet weak var studentSchool: UILabel!
    @IBOutlet weak var studentGuardians: UILabel!
    @IBOutlet weak var studentContacts: UILabel!
    @IBOutlet weak var studentAge: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

        setDOB()
        fillPage()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func fillPage() {
        let student = students[0]
        studentName.text = student["name"] as? String
        studentSchool.text = student["school"] as? String
        studentDOB.text = dob.fullDateAmerican()
        studentAge.text = String(calcAge())
        studentGuardians.text = guardianList()
        studentContacts.text = contactList()
    }
    
    func setStudentID(id: String) {
       studentID = id
    }

    private func setDOB(){
        let student = students[0]
        dob = Date(day: student["birthDay"] as! Int, month: student["birthMonth"] as! Int, year: student["birthYear"] as! Int)
    }
    
    private func calcAge() -> Int {
        return dob.age()
    }

    private func guardianList() -> String {
        var guardianList = ""
        for (var i = 0; i < guardians.count; i++) {
            let guardian = guardians[i]
            guardianList.appendContentsOf((guardian["name"] as? String)!)
            if ((i + 1) < guardians.count) {
                guardianList.appendContentsOf(", ")
            }
        }
        return guardianList
    }

    private func contactList() -> String {
        var contactList = ""
        for (var i = 0; i < contactNumbers.count; i++) {
            let contact = contactNumbers[i]
            contactList.appendContentsOf((contact["name"] as? String)!)
            contactList.appendContentsOf(": ")
            contactList.appendContentsOf(String((contact["number"] as? Int)!))
            if ((i + 1) < contactNumbers.count) {
                contactList.appendContentsOf(", ")
            }
        }
        return contactList
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
