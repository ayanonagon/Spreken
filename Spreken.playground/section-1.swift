// Playground - noun: a place where people can play

import UIKit

let url = NSURL(string: "http://www.stackoverflow.com")

let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
    println(NSString(data: data, encoding: NSUTF8StringEncoding))
}

task.resume()