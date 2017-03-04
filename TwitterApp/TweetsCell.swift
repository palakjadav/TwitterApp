//
//  TweetsCell.swift
//  TwitterApp
//
//  Created by Palak Jadav on 3/1/17.
//  Copyright © 2017 flounderware. All rights reserved.
//

import UIKit

class TweetsCell: UITableViewCell {
    
    @IBOutlet weak var userProfileImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    
    
    
    var wasRetweeted: Bool = false
    var wasFavorited: Bool = false
    
    
    var tweet: Tweet! {
        didSet {
            
            userName.text = tweet.user?.name as String?
            userHandle.text = "@ " + ((tweet.user?.screenname)! as String)
            tweetText.text = tweet.text as String?
            timeStamp.text = "\(tweet.timestamp!)"
            
            userProfileImage.setImageWith((tweet.user?.profileUrl)! as URL)
            //print("\(tweet.user?.profileUrl)!")
            
            
            if tweet.retweetCount != 0 && tweet.retweetCount < 1000 {
                retweetLabel.text = String(tweet.retweetCount)
            }
            else if tweet.retweetCount > 1000 {
                retweetLabel.text = "\(Double(tweet.retweetCount/1000)) k"
            }
            
            
            if tweet.favoritesCount != 0 && tweet.favoritesCount < 1000 {
                
                favoriteLabel.text = String(tweet.favoritesCount)
            }
            else if tweet.favoritesCount > 1000 {
                favoriteLabel.text = "\(Double(tweet.favoritesCount/1000)) k"
            }
            
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func onRetweetButton(_ sender: Any) {
        
        if wasRetweeted == false {
            
            
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControlState.normal)
            
            TwitterClient.sharedInstance?.retweet(id: tweet.tweetID!, success: { (tweet) in
                
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
            
            retweetLabel.text = "\((tweet.retweetCount)+1)"
            wasRetweeted = true
            
        }
        else {
            
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControlState.normal)
            retweetLabel.text = "\((tweet.retweetCount))"
            wasRetweeted = false
            
        }
        
    }
    
    @IBAction func onFavoriteButton(_ sender: Any) {
        
        if wasFavorited == false {
            
            favoriteButton.setImage(UIImage(named: "favor-icon-red"), for: UIControlState.normal)
            
            TwitterClient.sharedInstance?.favorited(id: tweet.tweetID!, success: {
                
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
            
            favoriteLabel.text = "\((tweet.favoritesCount)+1)"
            wasFavorited = true
            
        }
        else {
            favoriteButton.setImage(UIImage(named: "favor-icon"), for: UIControlState.normal)
            favoriteLabel.text = "\((tweet.favoritesCount))"
            wasFavorited = false
            
        }
    }


}
