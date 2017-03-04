//
//  TweetsViewController.swift
//  TwitterApp
//
//  Created by Palak Jadav on 2/28/17.
//  Copyright © 2017 flounderware. All rights reserved.
//

import UIKit
import Foundation

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]!

    override func viewDidLoad() {
        super.viewDidLoad()
   
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120

        /*TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets =  tweets

            for tweet in tweets {
                print("Palak's Tweet:\(tweet.text)")
                print(tweet.text ?? 0)
                //print("in tweet")
            }
        }, failure: { (error: NSError) in
            print(error.localizedDescription)
        })*/
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            for tweet in tweets {
                print(tweet.text!)
            }
        }, failure: { (error: Error) -> () in
            print(error.localizedDescription)
        })


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        cell.tweet = tweets![indexPath.row]
        cell.selectionStyle = .none
        
        
        return cell
        
    }

    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
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


