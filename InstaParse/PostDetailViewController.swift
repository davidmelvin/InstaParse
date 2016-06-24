//
//  PostDetailViewController.swift
//  InstaParse
//
//  Created by David Melvin on 6/23/16.
//  Copyright © 2016 David Melvin. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class PostDetailViewController: UIViewController {
    
    var window: UIWindow?
    
    var post: PFObject?
    
    @IBOutlet weak var postDetailUsernameLabel: UILabel!
    
    @IBOutlet weak var postDetailImageView: PFImageView!
    
    @IBOutlet weak var postDetailLocationLabel: UILabel!
    @IBOutlet weak var postDetailTimeLabel: UILabel!
    @IBOutlet weak var psotCommentLabel: UILabel!
    @IBOutlet weak var postCaptionLabel: UILabel!
    @IBOutlet weak var postDetailLikesLabel: UILabel!
    
   
    
    @IBAction func likePressed(sender: AnyObject) {
        if var likedByArray = self.post!["likedBy"] as? [PFUser] {
            if (likedByArray.contains(PFUser.currentUser()!))
            {
                likedByArray = likedByArray.filter() { $0 !== PFUser.currentUser() }
                print("Already Liked:")
            }
            else {
                likedByArray.append(PFUser.currentUser()!)
                print("First time liked")
                
                
            }
            self.post!["likedBy"] = likedByArray
            self.post!.saveInBackground()
            
            print("\(likedByArray.count) users have liked this")
            //print(likedByArray)
            
            
        }
        else {
            print("Liked by array doesn't exist")
            var newLikedByArray : [PFUser] = []
            newLikedByArray.append(PFUser.currentUser()!)
            self.post!["likedBy"] = newLikedByArray
            self.post!.saveInBackground()
           
        }
        self.postDetailLikesLabel.text = "\(self.post!["likedBy"].count) likes"
        if self.post!["likedBy"].count == 1 {
            self.postDetailLikesLabel.text = "1 like"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        self.postDetailImageView.file = self.post!["media"] as? PFFile
        self.postDetailImageView.loadInBackground()
        self.postDetailUsernameLabel.text = self.post!["author"].username
        let dateUpdated = self.post!.createdAt! as NSDate
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "EEE, MMM d, h:mm a"
        self.postDetailTimeLabel.text = NSString(format: "%@", dateFormat.stringFromDate(dateUpdated)) as String
        self.postCaptionLabel.text = self.post!["caption"] as? String
        
        if let likedByArray = self.post!["likedBy"] as? [PFUser] {
            self.postDetailLikesLabel.text = "\(likedByArray.count) likes"
            if likedByArray.count == 1 {
                self.postDetailLikesLabel.text = "1 like"
            }
        }
        else {
            self.postDetailLikesLabel.text = "0 likes"
        }
        
        //print(post)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogOut(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) in
            // PFUser.currentUser() will now be nil
            
            
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let loginViewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController")
            
            self.window?.rootViewController = loginViewController
            self.window?.makeKeyAndVisible()
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
