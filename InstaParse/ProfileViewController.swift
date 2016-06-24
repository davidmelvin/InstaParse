//
//  ProfileViewController.swift
//  InstaParse
//
//  Created by David Melvin on 6/23/16.
//  Copyright © 2016 David Melvin. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class ProfileViewController: UIViewController, UICollectionViewDataSource {
    
    var window: UIWindow?
    
    var posts : [PFObject] = []
    var refreshControl = UIRefreshControl()

    @IBOutlet weak var profileCollectionView: UICollectionView!
    @IBOutlet weak var noPostsLabel: UILabel!
    var user : PFUser = PFUser.currentUser()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileCollectionView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        profileCollectionView.insertSubview(refreshControl, atIndex: 0)
        
        refreshControlAction(refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return posts.count
        }
        
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("profilePhotoCell", forIndexPath: indexPath) as! ProfileCollectionViewCell
        
           cell.profileCellImageView.file = posts[indexPath.item]["media"] as? PFFile
            cell.profileCellImageView.loadInBackground()
            return cell
        }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        // construct PFQuery
        let query = PFQuery(className: "Post")
        query.whereKey("author", equalTo: user)
        query.orderByDescending("createdAt")
        query.includeKey("author")
        //query.limit = (infiniteScrollCount+1)*POSTSPERSCROLL
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
            if let posts = posts {
                // do something with the data fetched
                self.posts = posts
                print("Found \(self.posts.count) objects")
                self.profileCollectionView.reloadData()
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                refreshControl.endRefreshing()
                //self.isMoreDataLoading = false
                if (self.posts.count == 0) {
                    self.noPostsLabel.hidden = false
                }
            } else {
                // handle error
                print(error?.localizedDescription)
            }
        }
        self.profileCollectionView.reloadData()
    
    
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
        let button = sender as! UIButton
        let view = button.superview!
        let cell = view.superview as! ProfileCollectionViewCell
        let indexPath = profileCollectionView.indexPathForCell(cell)
        let post = posts[indexPath!.item]
        let detailViewController = segue.destinationViewController as! PostDetailViewController
        detailViewController.post = post
    }
}



 

