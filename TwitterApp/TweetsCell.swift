//
//  TweetsCell.swift
//  TwitterApp
//
//  Created by Palak Jadav on 3/1/17.
//  Copyright © 2017 flounderware. All rights reserved.
//

import UIKit
protocol TweetTableViewCellDelegate: class  {
    func profileImageViewTapped(cell: TweetsCell, user: User)
}

class TweetsCell: UITableViewCell {
    var tweet: Tweet!
    @IBOutlet weak var userProfileImage: UIImageView! {
        didSet{
            self.userProfileImage.isUserInteractionEnabled = true //make sure this is enabled
            //tap for userImageView
            let userProfileTap = UITapGestureRecognizer(target: self, action: #selector(userProfileTapped(_:)))
            self.userProfileImage.addGestureRecognizer(userProfileTap)
        }
    }
    func userProfileTapped(_ gesture: UITapGestureRecognizer) {
        if let delegate = delegate{
            delegate.profileImageViewTapped(cell: self, user: self.tweet.user!)
        }
    }
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    weak var delegate: TweetTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
