//
//  Tweet.swift
//  TwitterApp
//
//  Created by Palak Jadav on 2/28/17.
//  Copyright © 2017 flounderware. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var user: User?
    var text: String?
    var timestamp: Date?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var tweetID: Int?
    
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: (dictionary["user"] as? NSDictionary)!)
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        tweetID = (dictionary["id_str"] as? Int) ?? 0
        
        let timestampString = dictionary["created_at"] as? String
        
        
        if let timestampString = timestampString {
            let formatter =  DateFormatter()
            formatter.dateFormat = "EEE MM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString) 
        }
        
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }

}
