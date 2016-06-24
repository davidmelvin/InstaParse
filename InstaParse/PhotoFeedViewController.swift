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
import MBProgressHUD

class PhotoFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    var window: UIWindow?
    @IBOutlet weak var homeFeedTableView: UITableView!
    
    var postsArray : [PFObject] = []
    var isMoreDataLoading = false
    let refreshControl = UIRefreshControl()
    var infiniteScrollCount = 0
    let POSTSPERSCROLL = 20

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize a UIRefreshControl
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        homeFeedTableView.insertSubview(refreshControl, atIndex: 0)
        
        homeFeedTableView.dataSource = self
        homeFeedTableView.delegate = self

        // Do any additional setup after loading the view.
        
        refreshControlAction(refreshControl)
        
        }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        // construct PFQuery
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = (infiniteScrollCount+1)*POSTSPERSCROLL
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
            if let posts = posts {
                // do something with the data fetched
                self.postsArray = posts
                print("Found \(self.postsArray.count) objects")
                self.homeFeedTableView.reloadData()
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                refreshControl.endRefreshing()
                self.isMoreDataLoading = false
            } else {
                // handle error
                print(error?.localizedDescription)
            }
        }
        self.homeFeedTableView.reloadData()

    
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = homeFeedTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - homeFeedTableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && homeFeedTableView.dragging) {
                isMoreDataLoading = true
                infiniteScrollCount += 1
                
            refreshControlAction(refreshControl)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.postsArray.count
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
    
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "postDetailSegue" {
            let button = sender as! UIButton
            let view = button.superview!
            let cell = view.superview as! PostTableViewCell
            let indexPath = homeFeedTableView.indexPathForCell(cell)
            let post = postsArray[indexPath!.row]
            let detailViewController = segue.destinationViewController as! PostDetailViewController
            detailViewController.post = post
        }
        else if segue.identifier == "userProfileSegue" {
            let button = sender as! UIButton
            let view = button.superview!
            let cell = view.superview as! PostTableViewCell
            let indexPath = homeFeedTableView.indexPathForCell(cell)
            let user = postsArray[indexPath!.row]["author"] as! PFUser
            let profileView = segue.destinationViewController as! ProfileViewController
            profileView.user = user
            
        }
        
    }
    

}
