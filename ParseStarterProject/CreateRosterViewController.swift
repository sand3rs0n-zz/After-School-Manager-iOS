//
//  CreateRosterViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 1/18/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class CreateRosterViewController: UIViewController {

    @IBOutlet weak var rosterName: UITextField!
    @IBOutlet weak var rosterType: UIPickerView!
    @IBOutlet weak var pickUpTime: UIDatePicker!
    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var endDate: UIDatePicker!
    @IBOutlet weak var endDateLabel: UILabel!


    private var options = ["Day Camp", "Week Camp", "After School Program"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        endDate.hidden = true;
        endDateLabel.hidden = true;

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent componenet: Int) -> Int {
        return options.count
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return options[row]
    }

    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int) {
        let selected = options[row]
        if (selected == "Day Camp") {
            endDate.hidden = true;
            endDateLabel.hidden = true;
        } else {
            endDate.hidden = false;
            endDateLabel.hidden = false;
        }
    }

    @IBAction func createRoster(sender: AnyObject) {
        if (rosterName.text != "") {
            let selected = rosterType.selectedRowInComponent(0)
            if (options[selected] == "Day Camp") {
                endDate.setDate(startDate.date, animated: true)
            }
            let roster = PFObject(className: "Rosters")
            roster["username"] = (currentUser?.username)
            roster["rosterType"] = selected
            roster["name"] = rosterName.text

            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            dateFormatter.dateFormat = "MM/dd/yyyy"

            var inputDate = dateFormatter.stringFromDate(startDate.date)
            var dateArr = inputDate.characters.split{$0 == "/"}.map(String.init)
            roster["startDay"] = Int(dateArr[1])
            roster["startMonth"] = Int(dateArr[0])
            roster["startYear"] = Int(dateArr[2])

            inputDate = dateFormatter.stringFromDate(endDate.date)
            dateArr = inputDate.characters.split{$0 == "/"}.map(String.init)
            roster["endDay"] = Int(dateArr[1])
            roster["endMonth"] = Int(dateArr[0])
            roster["endYear"] = Int(dateArr[2])

            dateFormatter.dateFormat = "h:mm:a"
            inputDate = dateFormatter.stringFromDate(pickUpTime.date)
            dateArr = inputDate.characters.split{$0 == ":"}.map(String.init)
            if (dateArr[2] == "PM") {
                dateArr[0] = String(Int(dateArr[0])! + 12)
            }
            roster["pickUpHour"] = Int(dateArr[0])
            roster["pickUpMinute"] = Int(dateArr[1])

            roster.saveInBackgroundWithBlock {
                (success: Bool, error:NSError?) -> Void in
                if(success) {
                    print("Saved")
                    self.performSegueWithIdentifier("CreateRosterToRosterList", sender: self)
                }
                else {
                    print("Error")
                }
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
