//
//  TweetComposeViewController.swift
//  Twitter
//
//  Created by Rohit Jhangiani on 5/22/15.
//  Copyright (c) 2015 5TECH. All rights reserved.
//

import UIKit

@objc protocol TweetComposeViewControllerDelegate {
    optional func tweetComposeViewController(tweetComposeViewController: TweetComposeViewController, didComposeTweet tweet: Tweet)
}


class TweetComposeViewController: UIViewController, UITextViewDelegate {
    
    enum Mode {
        case Compose
        case Reply
    }
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var composeTextView: UITextView!
    @IBOutlet weak var charCountLabel: UILabel!
    
    var placeHolderText = "What's happening?"
    var replyFromUser: String?
    var replyToTweetId: String?
    var mode = Mode.Compose
    
    weak var delegate: TweetComposeViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        composeTextView.delegate = self
        var profileImageUrl = NSURL(string: User.currentUser!.profileImageUrl!)
        profileImageView.setImageWithURL(profileImageUrl)
        nameLabel.text = User.currentUser!.name
        handleLabel.text = "@\(User.currentUser!.screenname!)"
        
        if replyFromUser != nil {
            mode = Mode.Reply
            prepareForReply()
        } else {
            prepareForCompose()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Misc. helpers
    
    func prepareForReply() {
        composeTextView.textColor == UIColor.blackColor()
        composeTextView.text = "@\(replyFromUser!) "
        updateCharCount()
        composeTextView.becomeFirstResponder()
    }
    
    func prepareForCompose() {
        composeTextView.textColor == UIColor.lightGrayColor()
        composeTextView.text = placeHolderText
    }
    
    // MARK: - IBActions
    
    @IBAction func onCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onTweet(sender: AnyObject) {
        TwitterClient.sharedInstance.tweet(composeTextView.text, replyToTweetId: self.replyToTweetId) { (tweet, error) -> () in
            self.delegate?.tweetComposeViewController!(self, didComposeTweet: tweet!)
            // NSNotificationCenter.defaultCenter().postNotificationName(tweetsUpdatedNotification, object: nil)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // MARK: - TextView Delegate
    
    func textViewDidBeginEditing(textView: UITextView) {
        textView.textColor == UIColor.blackColor()
        if mode == Mode.Compose {
            composeTextView.text = String()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.textColor == UIColor.blackColor() {
            textView.text = placeHolderText
            textView.textColor == UIColor.lightGrayColor()
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        updateCharCount()
    }
    
    func updateCharCount() {
        charCountLabel.text = "\(140 - count(composeTextView.text))"
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
