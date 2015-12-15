//
//  StudentRosterViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 12/12/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class StudentRosterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var rosterState: RosterState = RosterState()
    private var students = [PFObject]()
    private var rosterID = 0
    @IBOutlet weak var titleBar: UINavigationItem!
    private var navTitle = ""
    
    override func viewDidLoad() {
        print(rosterID)
        super.viewDidLoad()
        self.titleBar.title = navTitle
        let query = PFQuery(className: "StudentRosters")
        query.whereKey("username", equalTo: (currentUser?.username)!)
        query.whereKey("rosterID", equalTo: rosterID)
        do {
            students = try query.findObjects()
        } catch {
        }
        print(students)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setState(state: RosterState) {
        rosterState = state
    }
    
    func setTitleValue(title: String) {
        navTitle = title
    }
    
    func setRosterID(id: Int) {
        rosterID = id
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let student: PFObject = students[indexPath.row]
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = student["studentName"] as? String
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let text = cell?.textLabel?.text
        print(text)
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
