//
//  LogInViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 12/12/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse
var currentUser = PFUser.currentUser()

class LogInViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logIn(sender: AnyObject) {
        if (username.text != "" && password.text != "") {
            PFUser.logInWithUsernameInBackground(username.text!, password: password.text!) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    currentUser = PFUser.currentUser()
                    self.performSegueWithIdentifier("LogInToHomePage", sender: self)
                } else {
                    print("Make sure you are using the correct username and password")
                }
            }
        } else {
            print("Make sure all fields have values!")
        }
        self.view.endEditing(true)
    }
    
    @IBAction func logOutUnwind(segue: UIStoryboardSegue) {
        PFUser.logOutInBackground()
        currentUser = PFUser.currentUser()
        username.text = ""
        password.text = ""
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        self.view.endEditing(true)
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
