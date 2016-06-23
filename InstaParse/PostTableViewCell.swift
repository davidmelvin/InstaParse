//
//  PostTableViewCell.swift
//  InstaParse
//
//  Created by David Melvin on 6/22/16.
//  Copyright © 2016 David Melvin. All rights reserved.
//

import UIKit
import ParseUI

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postUserImage: UIImageView!
    @IBOutlet weak var postUsernameLabel: UILabel!
    @IBOutlet weak var postLocationLabel: UILabel!
    @IBOutlet weak var postTimeLabel: UILabel!
    @IBOutlet weak var postImage: PFImageView!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
