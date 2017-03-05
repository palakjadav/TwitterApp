//
//  TweetDetailsViewController.swift
//  TwitterApp
//
//  Created by Palak Jadav on 3/3/17.
//  Copyright © 2017 flounderware. All rights reserved.
//

import UIKit
import Foundation

class TweetDetailsViewController: UIViewController {
    
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    
    @IBOutlet weak var favouriteLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favouriteButton: UIButton!
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userProfileImage.setImageWith(tweet.user?.profileUrl as! URL)
        userName.text = tweet.user?.name!
        userHandle.text = "@\((tweet.user?.screenname)!)"
        tweetText.text = tweet.text!
        userProfileImage.layer.cornerRadius = 2
        userProfileImage.clipsToBounds = true
        //replyCountLabel.text = ""
       /* bigRetweetsLabel.text = String(tweet.retweetCount)
        bigLikesLabel.text = String(tweet.likeCount)
        smallRetweetCountLabel.text = String(tweet.retweetCount)
        smallLikesCountLabel.text = String(tweet.likeCount)*/
        
        // Set retweet icon
        if tweet.retweeted {
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControlState())
        } else {
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControlState())
        }
        
        
        // Set like icon
        if tweet.favorited {
            favouriteButton.setImage(UIImage(named: "favor-icon-red"), for: UIControlState())
        } else {
            favouriteButton.setImage(UIImage(named: "favor-icon"), for: UIControlState())
        }


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onRetweet(_ sender: UIButton) {
        let path = tweet.id
        
        if tweet.retweeted == false {
            TwitterClient.sharedInstance!.retweet(id: path, params: nil) { (error) -> () in
                print("Retweeting from TweetsDetailViewController")
                self.tweet.retweetCount += 1
                self.tweet.retweeted = true
                // Reload data
                self.retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControlState())
                //self.bigRetweetsLabel.text = String(self.tweet.retweetCount)
               // self.smallRetweetCountLabel.text = String(self.tweet.retweetCount)
                
            }
        } else if tweet.retweeted == true {
            TwitterClient.sharedInstance!.unretweet(id: path, params: nil, completion: { (error) -> () in
                print("Unretweeting from TweetsDetailViewController")
                self.tweet.retweetCount -= 1
                self.tweet.retweeted = false
                // Reload data
                self.retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControlState())
                //self.bigRetweetsLabel.text = String(self.tweet.retweetCount)
               // self.smallRetweetCountLabel.text = String(self.tweet.retweetCount)
            })
        }
        

    }

    @IBAction func onFav(_ sender: UIButton) {
        let path = tweet.id
        if tweet.favorited == false {
            TwitterClient.sharedInstance!.favourite(id: path, params: nil) { (error) -> () in
                print("Liking from TweetsDetailViewController")
                self.tweet.favoritesCount += 1
                self.tweet.favorited = true
                // Reload data
                self.favouriteButton.setImage(UIImage(named: "facor-icon-red"), for: UIControlState())
               // self.bigLikesLabel.text = String(self.tweet.likeCount)
               // self.smallLikesCountLabel.text = String(self.tweet.likeCount)
                
            }
        } else if tweet.favorited == true {
            TwitterClient.sharedInstance!.unfavourite(id: path, params: nil, completion:  { (error) -> () in
                print("Unliking from TweetsDetailViewController")
                self.tweet.favoritesCount -= 1
                self.tweet.favorited = false
                // Reload data
                self.favouriteButton.setImage(UIImage(named: "favor-icon"), for: UIControlState())
                //self.bigLikesLabel.text = String(self.tweet.likeCount)
               // self.smallLikesCountLabel.text = String(self.tweet.likeCount)
            })
        }

    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
