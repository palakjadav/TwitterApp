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
        deauthorize()

        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterapp://oauth")! as URL!, scope: nil, success: {
            (requestToken: BDBOAuth1Credential?) -> Void in
             print("I got a token!")
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
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }
    
    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString:url.query)
        
       fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            self.currentAccount(success: { (user: User) in
            User.currentUser =  user
            self.loginSuccess?()
        }, failure: { (error: NSError) in
            self.loginFailure?(error)
        })
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
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error as NSError)
        })
       
        
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (NSError) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: { (nil) in
        }, success: { (task: URLSessionDataTask, response: Any) in

            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
        },
           failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error as NSError)
        })
    }
    
    func retweet(id: Int, params: NSDictionary?, completion: @escaping (_ error: Error?) -> ()) {
        post("1.1/statuses/retweet/\(id).json", parameters: params, success: {(operation: URLSessionDataTask!, response: Any?) -> Void in
            print("Retweeted tweet with id: \(id)")
            completion(nil)
        }, failure: { (operation: URLSessionDataTask?, error: Error!) -> Void in
            print("Error retweeting")
            completion(error as Error?)
        }
        )
    }
    
    func unretweet(id: Int, params: NSDictionary?, completion: @escaping (_ error: Error?) -> ()) {
        post("1.1/statuses/unretweet/\(id).json", parameters: params, success: { (operation: URLSessionDataTask!, response: Any?) -> Void in
            print("Unretweeted tweet with ide: \(id)")
            completion(nil)
        }, failure: { (operation: URLSessionDataTask?, error: Error?) -> Void in
            print("Error unretweeting")
            completion(error as Error?)
        }
        )
    }
    
    func favourite(id: Int, params: NSDictionary?, completion: @escaping (_ error: Error?) -> ()) {
        post("1.1/favorites/create.json?id=\(id)", parameters: params, success: { (operation: URLSessionDataTask!, response: Any?) -> Void in
            print("Liked tweet with id: \(id)")
            completion(nil)
        }, failure: { (operation: URLSessionDataTask?, error: Error?) -> Void in
            print("Error liking tweet with id: \(id)")
            completion(error as Error?)
        })
    }
    
    func unfavourite(id: Int, params: NSDictionary?, completion: @escaping (_ error: Error?) -> ()) {
        post("1.1/favorites/destroy.json?id=\(id)", parameters: params, success: { (operation: URLSessionDataTask!, response: Any?) -> Void in
            print("Unliked tweet with id: \(id)")
            completion(nil)
        }, failure: { (operation: URLSessionDataTask?, error: Error?) -> Void in
            print("Error unliking tweet with id: \(id)")
            completion(error as Error?)
        })
    }
    
    func compose(tweetText: String, params: NSDictionary?, completion: @escaping (_ error: Error?) -> () ){
        post("1.1/statuses/update.json?status=\(tweetText)", parameters: params, success: { (operation: URLSessionDataTask!, response: Any?) -> Void in
            print("tweeted: \(tweetText)")
            completion(nil)
        }, failure: { (operation: URLSessionDataTask?, error: Error?) -> Void in
            print("Couldn't compose")
            completion(error as Error?)
        }
        )
    }

}
