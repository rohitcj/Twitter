//
//  TwitterClient.swift
//  Twitter
//
//  Created by Rohit Jhangiani on 5/19/15.
//  Copyright (c) 2015 5TECH. All rights reserved.
//

import UIKit

// constants
let twitterConsumerKey = "jGU8fLK3pmRYDftmM1lZGc7q7"
let twitterConsumerSecret = "PwapYsrZv8fPXOr9dmNPINzRB6o1NefmmQAbexTGhC9npYTGB9"
let twitterBaseUrl = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
   
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseUrl, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        println("Getting the home timeline")
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            // println(" got user timeline: \(response)")
            var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error occured while getting the home timeline \(error)")
                completion(tweets: nil, error: error)
        })
    }
    
    func mentionsTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        println("Getting the mentions timeline")
        GET("1.1/statuses/mentions_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            // println(" got mentions timeline for user: \(response)")
            var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error occured while getting the mentions timeline \(error)")
                completion(tweets: nil, error: error)
        })
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        self.loginCompletion = completion
        
        // Fetch request token & rediret to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "techtwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            println("Got the request token: \(requestToken.token)")
            var authUrl = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authUrl!)
            }) { (error: NSError!) -> Void in
                println("Failed to get request token")
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) ->
            Void in
            println("Got the access token")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(
                accessToken)
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                var user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                self.loginCompletion?(user: user, error: nil)
                }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                    println("Error getting current user")
                    self.loginCompletion?(user: nil, error: error)
                })
            
            }) { (error: NSError!) -> Void in
                println("Failed to receive access token")
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func tweet(tweetText: String, replyToTweetId: String?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        var params: NSDictionary?
        if let replyToTweetId = replyToTweetId {
            params = ["status": tweetText, "in_reply_to_status_id": replyToTweetId]
        } else {
            params = ["status": tweetText]
        }
        POST("1.1/statuses/update.json", parameters: params, success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
            println("Tweeted successfully")
            var tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error occured while tweeting")
                completion(tweet: nil, error: nil)
        })
    }
    
    func favorite(tweetId: String, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        var params: NSDictionary? = ["id_str": tweetId]
        POST("1.1/favorites/create.json?id=\(tweetId)", parameters: params, success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
            println("Tweet favorited")
            var tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error occured while favoriting")
                completion(tweet: nil, error: nil)
        })
    }
    
    func unfavorite(tweetId: String, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        var params: NSDictionary? = ["id_str": tweetId]
        POST("1.1/favorites/destroy.json?id=\(tweetId)", parameters: params, success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
            println("Tweet unfavorited")
            var tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error occured while favoriting")
                completion(tweet: nil, error: nil)
        })
    }
    
    func retweet(tweetId: String, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        var params: NSDictionary? = ["id_str": tweetId]
        POST("1.1/statuses/retweet/\(tweetId).json", parameters: params, success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
            var tweet = Tweet(dictionary: response as! NSDictionary)
            println("Retweeted with id: \(tweet.id!)")
            completion(tweet: tweet, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error occured while retweeting")
                completion(tweet: nil, error: nil)
        })
    }
    
    func unretweet(tweetId: String, completion: (tweet: Tweet?, error: NSError?) -> ()){
        var retweetId: String?
        var params: NSDictionary? = ["id_str": tweetId, "include_my_retweet": true]
        GET("1.1/statuses/show.json?id=\(tweetId)", parameters: params, success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
            var tweet = Tweet(dictionary: response as! NSDictionary)
            retweetId = tweet.currentUserRetweetId!
            println("Retweet id: \(retweetId!)")
            self.deleteTweet(retweetId!, completion: completion)
            completion(tweet: tweet, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error occured while unretweeting: \(error.description)")
                completion(tweet: nil, error: nil)
        })
    }
    
    func deleteTweet(tweetId: String, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        var params: NSDictionary? = ["id_str": tweetId]
        println("Deleting tweet id: \(tweetId)")
        POST("1.1/statuses/destroy.json?id=\(tweetId)", parameters: params, success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
            println("tweet id \(tweetId) deleted")
            var tweet = Tweet(dictionary: response as! NSDictionary)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error occured while deleting the tweet")
                completion(tweet: nil, error: nil)
            })
    }
}
