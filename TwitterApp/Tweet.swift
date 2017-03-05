//
//  Tweet.swift
//  TwitterApp
//
//  Created by Palak Jadav on 2/28/17.
//  Copyright © 2017 flounderware. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var id: Int
    var user: User?
    var text: String?
    var rawTimestamp: Date?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var tweetID: Int?
    var retweeted: Bool
    var favorited: Bool
    
    init(dictionary: NSDictionary) {
        
        id = dictionary["id"] as! Int
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        retweeted = dictionary["retweeted"] as! Bool
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favorited = dictionary["favorited"] as! Bool
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        tweetID = (dictionary["id_str"] as? Int) ?? 0
        
        let timestampString = dictionary["created_at"] as? String
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MM d HH:mm:ss Z y"
        if let timestampString = timestampString {
            rawTimestamp = formatter.date(from: timestampString)
            print("\(rawTimestamp)\n\(formatter.string(from: rawTimestamp!))")
            //            formattedTimestamp = formatTimestamp(rawTimestamp!)
            //            print("Formatted timestamp: \(formattedTimestamp)")
        }    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
    func formatTimestamp(_ rawTimestamp: Date) -> String {
        let timeSince = abs(Int(rawTimestamp.timeIntervalSinceNow))
        let largestUnitChar: String
        let largestUnitDivisor: Int
        
        if (timeSince < 60) {
            largestUnitChar = "s" // Seconds
            largestUnitDivisor = 1
        } else if (timeSince/60 <= 60) {
            largestUnitChar = "m" // Minutes
            largestUnitDivisor = 60
        } else if (timeSince/60/60 <= 24) {
            largestUnitChar = "h" // Hours
            largestUnitDivisor = 60 * 60
        } else if (timeSince/60/60/24 <= 365) {
            largestUnitChar = "d" // Days
            largestUnitDivisor = 60 * 60 * 24
        } else {
            largestUnitChar = "y" // Years
            largestUnitDivisor = 60 * 60 * 24 * 365
        }
        return "\(timeSince / largestUnitDivisor)\(largestUnitChar)"
    }
}
