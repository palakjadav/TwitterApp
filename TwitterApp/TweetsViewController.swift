//
//  TweetsViewController.swift
//  TwitterApp
//
//  Created by Palak Jadav on 2/28/17.
//  Copyright © 2017 flounderware. All rights reserved.
//

import UIKit
import AFNetworking

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]!

    override func viewDidLoad() {
        super.viewDidLoad()
   
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120

        TwitterClient.sharedInstance!.homeTimeline(success: { (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()

        }, failure: { (error: Error) -> () in
            print(error.localizedDescription)
        })
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetsCell", for: indexPath) as! TweetsCell
        
        let tweet = tweets[indexPath.row]
        cell.tweet = tweet
        cell.userName.text = tweet.user?.name!
        cell.userHandle.text = "@\(tweet.user!.screenname!)"
        cell.tweetText.text = tweet.text!
        cell.userProfileImage.setImageWith(tweet.user?.profileUrl as! URL)
        cell.userProfileImage.layer.cornerRadius = 2
        cell.userProfileImage.clipsToBounds = true
        cell.timeStamp.text = tweet.formatTimestamp(tweet.rawTimestamp!)
        //cell.replyCountLabel.text = ""
        cell.selectionStyle = .none
        
        if tweet.retweeted {
            cell.retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControlState())
        } else {
            cell.retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControlState())
        }
        cell.retweetLabel.text = String(tweet.retweetCount)
        
        // Set like icon
        if tweet.favorited {
            cell.favoriteButton.setImage(UIImage(named: "favor-icon-red"), for: UIControlState())
        } else {
            cell.favoriteButton.setImage(UIImage(named: "favor-icon"), for: UIControlState())
        }
        cell.favoriteLabel.text = String(tweet.favoritesCount)
        
        // Set delegate for profile tap
      //  cell.delegate = self
        cell.tag = indexPath.row
        return cell
        
    }

    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
    }
    
    
    @IBAction func onRetweet(_ sender: Any) {
        let button = sender as! UIButton
        let view = button.superview!
        let cell = view.superview as! TweetsCell
        // Specify a cell
        let indexPath = tableView.indexPath(for: cell)
        let tweet = tweets![indexPath!.row]
        let path = tweet.id
        
        if tweet.retweeted == false {
            TwitterClient.sharedInstance!.retweet(id: path, params: nil) { (error) -> () in
                print("Retweeting from TweetsViewController")
                self.tweets![indexPath!.row].retweetCount += 1
                tweet.retweeted = true
                self.tableView.reloadData()
            }
        } else if tweet.retweeted == true {
            TwitterClient.sharedInstance!.unretweet(id: path, params: nil, completion: { (error) -> () in
                print("Unretweeting from TweetsViewController")
                self.tweets![indexPath!.row].retweetCount -= 1
                tweet.retweeted = false
                self.tableView.reloadData()
            })
        }
 
    }
    
    @IBAction func onFav(_ sender: Any) {
        let button = sender as! UIButton
        let view = button.superview!
        let cell = view.superview as! TweetsCell
        
        let indexPath = tableView.indexPath(for: cell)
        let tweet = tweets![indexPath!.row]
        
        let path = tweet.id
        if tweet.favorited == false {
            TwitterClient.sharedInstance!.favourite(id: path, params: nil) { (error) -> () in
                print("Liking from TweetsViewController")
                self.tweets![indexPath!.row].favoritesCount += 1
                tweet.favorited = true
                self.tableView.reloadData()
            }
        } else if tweet.favorited == true {
            TwitterClient.sharedInstance!.unfavourite(id: path, params: nil, completion:  { (error) -> () in
                print("Unliking from TweetsViewController")
                self.tweets![indexPath!.row].favoritesCount -= 1
                tweet.favorited = false
                self.tableView.reloadData()
            })
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       // if (segue.identifier == "detailViewSegue") {
            
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let tweetData = tweets[(indexPath?.row)!]
            let detailViewController = segue.destination as! TweetDetailsViewController
            
            detailViewController.tweet = tweetData
            
       // }
    /*else if (segue.identifier == "composeSegue") {
            print("Called composeSegue")
            let composeViewController = segue.destination as! ComposeViewController
            //            composeViewController.testLabel.text = "Successfully segued and sent this string from the tweets view controller to this compose view controller"
        }*/
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        print("segue")
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
 
        let twe = [self.tweets[(indexPath?.row)!]]
        
        let tweetsViewController = segue.destination as! TweetDetailsViewController
        tweetsViewController.tweets = twe
    }*/
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
/*
extension TweetsViewController: TweetTableViewCellDelegate{
    func profileImageViewTapped(cell: TweetCell, user: User) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileViewController" ) as? ProfileViewController {
            profileVC.user = user //set the profile user before your push
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
}
*/

