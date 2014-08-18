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

    class func fetchAll(account: ACAccount, callback:(Array<Tweet> -> Void)?) {
        let url = NSURL.URLWithString("https://api.twitter.com/1.1/statuses/user_timeline/\(account.username).json")
        let params = ["include_rts": "true",
            "trim_user" : "1",
            "count": "2"]

        let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: url, parameters: params)
        request.account = account
        request.performRequestWithHandler { (responseData, urlResponse, error) in
            if (responseData != nil) {
                if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                    var jsonError: NSError?
                    let timelineData: AnyObject! = NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.AllowFragments, error: &jsonError)
                    if (timelineData != nil) {
                        println("\(timelineData)")
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
