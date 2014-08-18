//
//  Tweet.swift
//  Spreken
//
//  Created by Ayaka Nonaka on 8/17/14.
//  Copyright (c) 2014 Ayaka Nonaka. All rights reserved.
//

import Foundation
import Social
import Accounts

class Tweet {

    let text: String

    var description: String {
        return "Tweet: \(self.text)"
    }

    init(text: String) {
        self.text = text
    }

    class func fetchAll(account: ACAccount, callback:((tweets: Array<Tweet>) -> Void)?) {
        let url = NSURL.URLWithString("https://api.twitter.com/1.1/statuses/home_timeline/\(account.username).json")
        let params = ["include_rts": "true",
                      "trim_user" : "1",
                      "count": "100"]

        let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: url, parameters: params)
        request.account = account
        request.performRequestWithHandler { (responseData, urlResponse, error) in
            if (responseData != nil) {
                if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                    var jsonError: NSError?
                    let timelineData = NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.AllowFragments, error: &jsonError) as NSArray
                    if (timelineData != nil) {
                        var tweets: Array<Tweet> = []
                        for tweetDict in timelineData {
                            let text = tweetDict.valueForKey("text") as String
                            let tweet = Tweet(text: text)
                            tweets.append(tweet)
                        }
                        callback?(tweets: tweets)
                    } else {
                        println("JSON Error: \(jsonError?.localizedDescription)")
                    }

                } else {
                    println("Got unsuccessful status code: \(urlResponse.statusCode)")
                }
            } else {
                println(error.localizedDescription)
            }
        }
    }
}
