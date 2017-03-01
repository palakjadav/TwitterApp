//
//  TwitterClient.swift
//  TwitterApp
//
//  Created by Palak Jadav on 2/28/17.
//  Copyright © 2017 flounderware. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string:"https://api.twitter.com") as URL!, consumerKey: "RTy86eGBWShLGa92UMRDh4fUq", consumerSecret: "XXIc7DTGtoIPYzqv8GUIWOzz9khK61exQlaYFxlO4Rb3xz4S7L")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    
    func login(success: @escaping () -> (), failure: @escaping (NSError) -> ()) {
        
        loginSuccess = success
        loginFailure =  failure
        TwitterClient.sharedInstance?.deauthorize()
        
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterapp://oauth")! as URL!, scope: nil, success: {
            (requestToken: BDBOAuth1Credential?) -> Void in
            // print("I got a token!")
            
            //            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")
            //                UIApplication.shared.open(url, options:[:], completionHandler: nil)
            //
            //            //UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
            if let request = requestToken?.token
            {
                let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(request)")!
                //This next line is to open other applications. ex: when cliking on a link and it open safari to view the contents
                //of the link. to switch out of your application to something else
                //UIApplication.shared.canOpenURL(url as URL!)
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
            
        }, failure: {(error: Error?) -> Void in
            print("Error: \(error!.localizedDescription)")
            self.loginFailure?(error as! NSError)
        })
    }
    
    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString:url.query)
        //let twitterClient = BDBOAuth1SessionManager(baseURL: NSURL(string:"https://api.twitter.com") as URL!, consumerKey: "RTy86eGBWShLGa92UMRDh4fUq", consumerSecret: "XXIc7DTGtoIPYzqv8GUIWOzz9khK61exQlaYFxlO4Rb3xz4S7L")
        
       fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            //print("I got the access token")
            
        /*    client?.homeTimeline(success: { (tweets: [Tweet]) in
                for tweet in tweets {
                    print(tweet.text ?? 0)
                }
            }, failure: { (error: NSError) in
                print("error: \(error.localizedDescription)")
            })
                        client?.currentAccount()
         */
        self.loginSuccess?()
        }, failure: { (error: Error?) -> Void in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error as! NSError)
        })

    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (NSError) -> ()) {
        
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            /*for tweet in tweets{
                print("here")
                print("\(tweet.text)")
            }*/
            
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            //print(error.localizedDescription)
            failure(error as NSError)
        })
       
        
    }
    
    func currentAccount() {
        
        get("1.1/account/verify_credentials.json", parameters: nil, progress: { (nil) in
        }, success: { (task: URLSessionDataTask, response: Any) in
            //print("account: \(response)")
            let userDictionary = response as! NSDictionary
            //print("user: \(user)")
            //print("name: \(user?["name"])")
            let user = User(dictionary: userDictionary)
            
            //print("name: \(user.name)")
            //print("screenname: \(user.screenname)")
           // print("profile url: \(user.profileUrl)")
           // print("description: \(user.tagline)")
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            
        })


    }
    
    

}
