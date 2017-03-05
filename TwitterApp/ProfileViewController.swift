//
//  ProfileViewController.swift
//  TwitterApp
//
//  Created by Palak Jadav on 3/4/17.
//  Copyright © 2017 flounderware. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var user: User!
    var tweet: Tweet!
    
    @IBOutlet weak var userHeaderView: UIImageView!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var tweetCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followersCount: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Strings
        userName.text = user.name!
        userHandle.text = "@\(user.screenname!)"
        //descriptionLabel.text = user.tagline!
        
        // Numbers
        tweetCount.text = String(user.tweetsCount)
        followingCount.text = String(user.followingCount)
        followersCount.text = String(user.followerCount)
        
        // Images
        userProfileImage.setImageWith(user.profileUrl as! URL)
        if user.profileBannerImageURL != nil {
            userHeaderView.setImageWith(user.profileBannerImageURL as! URL)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
