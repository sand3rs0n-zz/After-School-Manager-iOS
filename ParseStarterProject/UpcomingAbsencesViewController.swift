//
//  UpcomingAbsencesViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 12/12/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class UpcomingAbsencesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var absenceList = [PFObject]()
    let date = NSDate()
    let calendar = NSCalendar.currentCalendar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let year = calendar.components(.Year, fromDate:date).year
        let query = PFQuery(className: "AbsencesList")
        query.whereKey("username", equalTo: (currentUser?.username)!)
        query.whereKey("year", greaterThanOrEqualTo: year)
        do {
            absenceList = try query.findObjects()
        } catch {
        }
        print(absenceList)
        removeOldDates()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func removeOldDates() {
        let year = calendar.components(.Year, fromDate:date).year
        let month = calendar.components(.Month, fromDate:date).month
        let day = calendar.components(.Day, fromDate:date).day
        for (var i = 0; i < absenceList.count; i++) {
            let currentAbsence = absenceList[i]
            if ((currentAbsence["year"] as! Int) == year && (currentAbsence["month"] as! Int) <= month && (currentAbsence["day"] as! Int) < day) {
                absenceList.removeAtIndex(i)
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let absence: PFObject = absenceList[indexPath.row]
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = absence["username"] as? String
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return absenceList.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let text = cell?.textLabel?.text
        print(text)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "UpcomingAbsencesToScheduleAbsenceRosterSelect") {
            let srvc = segue.destinationViewController as? RosterTypeViewController
            srvc?.setState(ScheduleAbsenceState())
        }
    }
    
    @IBAction func scheduleAbsenceUnwind(segue: UIStoryboardSegue) {
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
