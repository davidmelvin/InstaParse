//
//  LoginViewController.swift
//  InstaParse
//
//  Created by David Melvin on 6/20/16.
//  Copyright © 2016 David Melvin. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignIn(sender: AnyObject) {
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""
        
        PFUser.logInWithUsernameInBackground(username, password: password) { (user: PFUser?, error: NSError?) in
            
        if let error = error {
            
                let alertController = UIAlertController(title: "Registration Error", message: error.localizedDescription, preferredStyle: .Alert)
                
                // create a cancel action
                let cancelAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
                    // handle cancel response here. Doing nothing will dismiss the view.
                }
                // add the cancel action to the alertController
                alertController.addAction(cancelAction)
                
                
                self.presentViewController(alertController, animated: true) {
                    // optional code for what happens after the alert controller has finished presenting
                }
                
                print(error.localizedDescription)
            
            }
        else {
                print("User \(self.usernameField.text!) has logged in")
                self.performSegueWithIdentifier("loginSegue", sender:  nil)
            }
        }
    }
    
    
    @IBAction func onSignUp(sender: AnyObject) {
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""
        
        // initialize a user object
        let newUser = PFUser()
        
        // set user properties
        newUser.username = username
        
        newUser.password = password
        
        // call sign up function on the object
        newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if let error = error {
                
                let alertController = UIAlertController(title: "Registration Error", message: error.localizedDescription, preferredStyle: .Alert)
                
                // create a cancel action
                let cancelAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
                    // handle cancel response here. Doing nothing will dismiss the view.
                }
                // add the cancel action to the alertController
                alertController.addAction(cancelAction)
                
                
                self.presentViewController(alertController, animated: true) {
                    // optional code for what happens after the alert controller has finished presenting
                }
                
                print(error.localizedDescription)
//                if error.code == 202 {
//                    print("Username is taken")
//                }
                
            } else {
                print("User Registered successfully")
                // manually segue to logged in view
                self.performSegueWithIdentifier("loginSegue", sender:  nil)
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
