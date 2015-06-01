//
//  Tweet.swift
//  Twitter
//
//  Created by Rohit Jhangiani on 5/20/15.
//  Copyright (c) 2015 5TECH. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var dictionary: NSDictionary?
    var user: User?
    var id: String?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var numRetweets: NSInteger?
    var isRetweeted: Bool?
    var numFavorites: NSInteger?
    var isFavorited: Bool?
    var currentUserRetweet: NSDictionary?
    var currentUserRetweetId: String?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        id = dictionary["id_str"] as? String
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        numRetweets = dictionary["retweet_count"] as? NSInteger
        isRetweeted = dictionary["retweeted"] as? Bool
        numFavorites = dictionary["favorite_count"] as? NSInteger
        isFavorited = dictionary["favorited"] as? Bool
        currentUserRetweet = dictionary["current_user_retweet"] as? NSDictionary
        if let currentUserRetweet = currentUserRetweet {
            currentUserRetweetId = currentUserRetweet["id_str"] as? String
        }
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }
    
    func populateCell(tableView: UITableView, atRow: Int) -> TweetCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as! TweetCell
        cell.tweet = self
        cell.profileImageView.setImageWithURL(NSURL(string: user!.profileImageUrl!), placeholderImage: UIImage(named: "Loading"))
        cell.profileImageView.tag = atRow
        cell.nameLabel.text = user?.name
        cell.handleLabel.text = "@\(user!.screenname!)"
        cell.timeLabel.text = timeToDisplay()
        cell.tweetTextLabel.text = text
        
        // time
        cell.retweetLabel.text = "\(numRetweets!)"
        cell.favoriteLabel.text = "\(numFavorites!)"
        return cell
    }
    
    func timeToDisplay() -> String {
        var currentDate = NSDate()
        var timeInterval = currentDate.timeIntervalSinceDate(createdAt!)
        var timeSinceCreation: String
        
        if (timeInterval < 60) {
            timeSinceCreation = "\(Int(timeInterval))s" // seconds
        } else {
            timeInterval = timeInterval/60 // minutes
            if (timeInterval < 60) {
                timeSinceCreation = "\(Int(timeInterval))m"
            } else {
                timeInterval = timeInterval/24  // hours
                if (timeInterval < 24) {
                    timeSinceCreation = "\(Int(timeInterval))h"
                } else {
                    timeInterval = timeInterval/30 // days
                    if (timeInterval < 31) {
                        timeSinceCreation = "\(Int(timeInterval))d"
                    } else {
                        timeInterval = timeInterval/12 // months
                        if (timeInterval < 12) {
                            timeSinceCreation = "\(Int(timeInterval)) months"
                        } else {
                            timeSinceCreation = "\(Int(timeInterval)) year"
                        }
                    }
                }
            }
        }
        return timeSinceCreation
    }
}
