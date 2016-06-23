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
    
    var post: PFObject?
    
    @IBOutlet weak var postDetailUsernameLabel: UILabel!
    
    @IBOutlet weak var postDetailImageView: PFImageView!
    
    @IBOutlet weak var postDetailLocationLabel: UILabel!
    @IBOutlet weak var postDetailTimeLabel: UILabel!
    
    
    @IBOutlet weak var postDetailImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postDetailImageView.file = self.post!["media"] as? PFFile
        self.postDetailImageView.loadInBackground()
        
//        cell.postImage.file = self.postsArray[indexPath.row]["media"] as? PFFile
//        cell.postImage.loadInBackground()
        
        self.postDetailUsernameLabel.text = self.post!["author"].username
        let dateUpdated = self.post!.createdAt! as NSDate
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "EEE, MMM d, h:mm a"
        self.postDetailTimeLabel.text = NSString(format: "%@", dateFormat.stringFromDate(dateUpdated)) as String
        
        
        
        print(post)
        
        //postImage.file = self.kgjhdchfrdhglnuedkfgbdjduccchlbdpostsArray[indexPath.row]["media"] as? PFFile

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
