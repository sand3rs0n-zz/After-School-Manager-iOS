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
    @IBOutlet weak var createRosterButton: UIButton!
    @IBOutlet weak var titleBar: UINavigationItem!
    @IBOutlet weak var deleteRosterButton: UIButton!

    private var state = 0
    private var navTitle = ""
    private var buttonText = ""
    private var existingRoster = [PFObject]()

    private var options = ["Day Camp", "Week Camp", "After School Program"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        endDate.hidden = true;
        endDateLabel.hidden = true;

        self.titleBar.title = navTitle
        self.createRosterButton!.setTitle(buttonText, forState: .Normal)

        if (state == 0) {
            hideElements()
        } else if (state == 1) {
            fillElements()
        }

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

    func setState(state: Int) {
        self.state = state
    }

    func setTitleValue(navTitle: String) {
        self.navTitle = navTitle
    }

    func setCreateRosterButtonValue(buttonText: String) {
        self.buttonText = buttonText
    }

    func setExistingRoster(roster: [PFObject]) {
        existingRoster = roster
    }

    private func hideElements() {
        deleteRosterButton.hidden = true
    }

    private func fillElements() {
        //put stuff in proper fields
        let roster = existingRoster[0]
        rosterName.text = roster["name"] as? String

        rosterType.selectRow(roster["rosterType"] as! Int, inComponent: 0, animated: true)
        if (roster["rosterType"] as! Int > 0) {
            endDate.hidden = false;
            endDateLabel.hidden = false;
        }

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"

        var dateString = String(roster["startDay"]) + "/" + String(roster["startMonth"]) + "/" + String(roster["startYear"])
        var convertedStartDate = dateFormatter.dateFromString(dateString)
        startDate.date = convertedStartDate!

        dateString = String(roster["endDay"]) + "/" + String(roster["endMonth"]) + "/" + String(roster["endYear"])
        convertedStartDate = dateFormatter.dateFromString(dateString)
        endDate.date = convertedStartDate!

        var hour = roster["pickUpHour"] as? Int
        var ampm = "AM"
        if (hour > 12) {
            hour = hour! - 12
            ampm = "PM"
        }
        dateFormatter.dateFormat = "h:m:a"
        dateString = String(hour!) +  ":" + String((roster["pickUpMinute"])) + ":" + ampm
        convertedStartDate = dateFormatter.dateFromString(dateString)
        pickUpTime.date = convertedStartDate!
    }

    @IBAction func backButton(sender: AnyObject) {
        back()
    }

    private func back() {
        if (state == 0) {
            performSegueWithIdentifier("ReturnToAllRostersUnwind", sender: self)
        } else if (state == 1) {
            performSegueWithIdentifier("ReturnToRosterUnwind", sender: self)
        }
    }

    @IBAction func deleteRoster(sender: AnyObject) {
        //delete all relevant stuff
    }

    @IBAction func createRoster(sender: AnyObject) {
        if (rosterName.text != "") {
            if (state == 1) {
                saveRoster(existingRoster[0])
            } else if (state == 0) {
                let roster = PFObject(className: "Rosters")
                saveRoster(roster)
            }
        }
    }

    private func saveRoster(roster: PFObject) {
        let selected = rosterType.selectedRowInComponent(0)
        if (options[selected] == "Day Camp") {
            endDate.setDate(startDate.date, animated: true)
        }

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
                self.back()
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
