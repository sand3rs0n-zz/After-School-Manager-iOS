//
//  SignUpViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 12/12/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createAccount(sender: AnyObject) {
        if (verifyFields()) {
            let user = PFUser()
            user.username = username.text!
            user.password = password.text!
            
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool, error: NSError?) -> Void in
                if (error == nil) {
                    PFUser.logInWithUsernameInBackground(self.username.text!, password: self.password.text!) {
                        (user: PFUser?, error: NSError?) -> Void in
                        currentUser = PFUser.currentUser()
                        self.createUserInfo()
                        self.performSegueWithIdentifier("CreateAccountToHomePage", sender: self)
                    }
                } else {
                    print(error?.description)
                    if (error?.code == 202) {
                        print("That username is already in use.")
                    }
                }
            }
        }
        
        self.view.endEditing(true)

    }
    
    private func createUserInfo() {
        let userInfo = PFObject(className: "UserInfo")
        userInfo["username"] = username.text!
        userInfo["name"] = name.text!
        userInfo["pin"] = "0000"
        userInfo.saveInBackgroundWithBlock {
            (success: Bool, error:NSError?) -> Void in
            if(success) {
                print("Saved")
            }
            else {
                print("Error")
            }
        }
    }
    
    private func verifyFields() -> Bool {
        if (username.text == "" || name.text == "" || password == "" || confirmPassword == "") {
            print("Please make sure all fields are filled")
            return false
        } else if (password.text!.characters.count < 8) {
            print("Please ensure your password is at least 8 characters long")
            return false
        } else if (!NSPredicate(format:"SELF MATCHES %@", ".*[A-Z]+.*").evaluateWithObject(password.text!) || !NSPredicate(format:"SELF MATCHES %@", ".*[0-9]+.*").evaluateWithObject(password.text!)) {
            print("Please ensure your password contains at least one Capital letter and one number.")
            return false
        } else if (password.text != confirmPassword.text!) {
            print("Your password and password confirmaton do not match")
            return false
        }
        return true
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
