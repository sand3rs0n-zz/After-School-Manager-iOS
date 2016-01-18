//
//  ScheduleAbsenceViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 12/15/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class ScheduleAbsenceViewController: UIViewController {

    private var studentID = ""
    private var studentLastName = ""
    private var studentFirstName = ""
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setStudentID(id: String) {
        studentID = id
    }

    func setStudentLastName(name: String) {
        studentLastName = name
    }

    func setStudentFirstName(name: String) {
        studentFirstName = name
    }

    @IBAction func schedule(sender: AnyObject) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let inputDate = dateFormatter.stringFromDate(datePicker.date)
        let dateArr = inputDate.characters.split{$0 == "/"}.map(String.init)


        let absence = PFObject(className: "AbsencesList")
        absence["username"] = (currentUser?.username)!
        absence["studentLastName"] = studentLastName
        absence["studentFirstName"] = studentFirstName
        absence["studentID"] = studentID
        absence["day"] = Int(dateArr[1])
        absence["month"] = Int(dateArr[0])
        absence["year"] = Int(dateArr[2])

        absence.saveInBackgroundWithBlock {
            (success: Bool, error:NSError?) -> Void in
            if(success) {
                print("Saved")
            }
            else {
                print("Error")
            }
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
