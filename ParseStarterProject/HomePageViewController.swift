/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class HomePageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func returnHomeUnwind(segue: UIStoryboardSegue) {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let srvc = segue.destinationViewController as? RosterTypeViewController
        if (segue.identifier == "HomePageToSignOutRosterSelect") {
            srvc?.setState(SignOutState())
        } else if (segue.identifier == "HomePageToStudentRosterSelect") {
            srvc?.setState(StudentRosterState())
        }
    }
}
