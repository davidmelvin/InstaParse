//
//  PhotoFeedViewController.swift
//  InstaParse
//
//  Created by David Melvin on 6/20/16.
//  Copyright © 2016 David Melvin. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class PhotoFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var window: UIWindow?
    @IBOutlet weak var homeFeedTableView: UITableView!
    
    var postsArray : [PFObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeFeedTableView.dataSource = self
        homeFeedTableView.delegate = self

        // Do any additional setup after loading the view.
        
        // construct PFQuery
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = 20
        
        
        
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
            if let posts = posts {
                // do something with the data fetched
                self.postsArray = posts
                print("Found \(self.postsArray.count) objects")
                self.homeFeedTableView.reloadData()
            } else {
                // handle error
                print(error?.localizedDescription)
            }
        }
        self.homeFeedTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.postsArray.count > 20) {
            return 20
        }
        else {
            return self.postsArray.count
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = homeFeedTableView.dequeueReusableCellWithIdentifier("postCellReuse", forIndexPath: indexPath) as! PostTableViewCell
        cell.postUsernameLabel.text = self.postsArray[indexPath.row]["author"].username
        
        let dateUpdated = self.postsArray[indexPath.row].createdAt! as NSDate
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "EEE, MMM d, h:mm a"
        cell.postTimeLabel.text = NSString(format: "%@", dateFormat.stringFromDate(dateUpdated)) as String
        
        //cell.postLocation.text = self.postsArray[indexPath.row]["location"]
        cell.postImage.file = self.postsArray[indexPath.row]["media"] as? PFFile
        cell.postImage.loadInBackground()

        //cell.postUserImage.text = self.postsArray[indexPath.row]["createdAt"].date
        

        return cell
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
