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
    private let date = Date()
    private let calendar = NSCalendar.currentCalendar()
    
    @IBOutlet weak var upcomingAbsencesListTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        getUpcomingAbsences()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func getUpcomingAbsences() {
        let query = PFQuery(className: "AbsencesList")
        query.whereKey("username", equalTo: (currentUser?.username)!)
        query.whereKey("year", greaterThanOrEqualTo: date.getCurrentYear())
        query.orderByAscending("month")
        query.addAscendingOrder("day")
        query.addAscendingOrder("studentLastName")
        do {
            absenceList = try query.findObjects()
        } catch {
        }
        removeOldDates()
    }
    
    private func removeOldDates() {
        let year = date.getCurrentYear()
        let month = date.getCurrentMonth()
        let day = date.getCurrentDay()
        for (var i = 0; i < absenceList.count; i++) {
            let currentAbsence = absenceList[i]
            if ((currentAbsence["year"] as! Int) < year) {
                absenceList.removeAtIndex(i)
                i--
            } else if ((currentAbsence["year"] as! Int) == year && (currentAbsence["month"] as! Int) < month) {
                absenceList.removeAtIndex(i)
                i--
            } else if ((currentAbsence["year"] as! Int) == year && (currentAbsence["month"] as! Int) == month && (currentAbsence["day"] as! Int) < day) {
                absenceList.removeAtIndex(i)
                i--
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let absence: PFObject = absenceList[indexPath.row]
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        var name = (absence["studentFirstName"] as? String)! + " " + (absence["studentLastName"] as? String)!
        let date = Date(day: absence["day"] as! Int, month: absence["month"] as! Int, year: absence["year"] as! Int)
        name.appendContentsOf("\t\t")
        name.appendContentsOf(date.fullDateAmerican())
        cell.textLabel?.text = name
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
            srvc?.setState(2)
        }
    }
    
    @IBAction func scheduleAbsenceUnwind(segue: UIStoryboardSegue) {
        getUpcomingAbsences()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.upcomingAbsencesListTable.reloadData()
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
