//
//  TweetCell.swift
//  Twitter
//
//  Created by Rohit Jhangiani on 5/21/15.
//  Copyright (c) 2015 5TECH. All rights reserved.
//

import UIKit

@objc protocol TweetCellDelegate {
    optional func tweetCell(tweetCell: TweetCell, didChangeFavoriteStatus status: Bool)
    optional func tweetCell(tweetCell: TweetCell, didChangeRetweetStatus status: Bool)
    optional func tweetCell(tweetCell: TweetCell, didTapReplyTweetId tweetId: String, fromUser: String)
}

class TweetCell: UITableViewCell {
    
    // outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteLabel: UILabel!
    
    // variables
    var tweet: Tweet?

    // delegates
    weak var delegate: TweetCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        handleLabel.preferredMaxLayoutWidth = handleLabel.frame.size.width
        tweetTextLabel.preferredMaxLayoutWidth = tweetTextLabel.frame.size.width
        retweetLabel.preferredMaxLayoutWidth = retweetLabel.frame.size.width
        favoriteLabel.preferredMaxLayoutWidth = favoriteLabel.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        handleLabel.preferredMaxLayoutWidth = handleLabel.frame.size.width
        tweetTextLabel.preferredMaxLayoutWidth = tweetTextLabel.frame.size.width
        retweetLabel.preferredMaxLayoutWidth = retweetLabel.frame.size.width
        favoriteLabel.preferredMaxLayoutWidth = favoriteLabel.frame.size.width
    }
    
    @IBAction func onReply(sender: AnyObject) {
        self.delegate?.tweetCell!(self, didTapReplyTweetId: self.tweet!.id!, fromUser: self.tweet!.user!.screenname!)
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        if !tweet!.isRetweeted! {
            retweetButton.setImage(UIImage(named: "retweetOn"), forState: UIControlState.Normal)
            var params: NSDictionary = ["id": tweet!.id!]
            TwitterClient.sharedInstance.retweet(tweet!.id!, completion: { (tweet, error) -> () in
                if tweet != nil {
                    self.retweetLabel.text = "\(++self.tweet!.numRetweets!)"
                    self.delegate?.tweetCell!(self, didChangeRetweetStatus: true)
                    return
                }
            })
        } else if tweet!.isRetweeted! {
            retweetButton.setImage(UIImage(named: "retweet"), forState: UIControlState.Normal)
            var params: NSDictionary = ["id": tweet!.id!]
            TwitterClient.sharedInstance.unretweet(tweet!.id!, completion: { (retweet, error) -> () in
                if retweet != nil {
                    self.retweetLabel.text = "\(--self.tweet!.numRetweets!)"
                    self.delegate?.tweetCell!(self, didChangeRetweetStatus: false)
                    return
                }
            })
        }
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        if !tweet!.isFavorited! {
            favoriteButton.setImage(UIImage(named: "favoriteOn"), forState: UIControlState.Normal)
            TwitterClient.sharedInstance.favorite(tweet!.id!, completion: { (tweet, error) -> () in
                if tweet != nil {
                    self.favoriteLabel.text = "\(++self.tweet!.numFavorites!)"
                    self.delegate?.tweetCell!(self, didChangeFavoriteStatus: true)
                }
            })
        }
        else {
            favoriteButton.setImage(UIImage(named: "favorite"), forState: UIControlState.Normal)
            var params: NSDictionary = ["id": tweet!.id!]
            TwitterClient.sharedInstance.unfavorite(tweet!.id!, completion: { (tweet, error) -> () in
                if tweet != nil {
                    self.favoriteLabel.text = "\(--self.tweet!.numFavorites!)"
                    self.delegate?.tweetCell!(self, didChangeFavoriteStatus: false)
                }
            })
        }
    }
}
