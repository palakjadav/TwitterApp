//
//  Tweet.swift
//  TwitterApp
//
//  Created by Palak Jadav on 2/28/17.
//  Copyright © 2017 flounderware. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var text: NSString?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favouritesCount: Int = 0
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String as NSString?
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favouritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        
        let timestampString = dictionary["created_at"] as? String
        
        
        if let timestampString = timestampString {
            let formatter =  DateFormatter()
            formatter.dateFormat = "EEE MM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString) as NSDate?
        }
        
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
        }
        return tweets
    }

}