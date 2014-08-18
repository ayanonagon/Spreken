//
//  TweetsViewController.swift
//  Spreken
//
//  Created by Ayaka Nonaka on 7/25/14.
//  Copyright (c) 2014 Ayaka Nonaka. All rights reserved.
//

import UIKit
import Social
import Accounts

class TweetsViewController: UITableViewController, UITableViewDataSource {

    let accountStore: ACAccountStore;
    let translator: Polyglot
    var tweets: Array<Tweet>

    required init(coder aDecoder: NSCoder!) {
        accountStore = ACAccountStore()
        translator = Polyglot(clientId: "", clientSecret: "")
        tweets = []
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "TweetCell")

        var english = "Hallo wereld"
        self.translateToEnglish("Hallo wereld")

        if (self.userHasAccessToTwitter()) {
            let twitterAccountType = self.accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
            self.accountStore.requestAccessToAccountsWithType(twitterAccountType, options: nil) {
                granted, error in
                if granted {
                    let twitterAccounts = self.accountStore.accountsWithAccountType(twitterAccountType)
                    if twitterAccounts.count == 0 {
                        let alertView = UIAlertView(title: "No Twitter accounts found",
                                                    message: "Please add a Twitter account in Settings.",
                                                    delegate: nil, cancelButtonTitle: "OK")
                        alertView.show()
                    } else {
                        let twitterAccount = twitterAccounts[0] as ACAccount
                        Tweet.fetchAll(twitterAccount) { tweets in
                            self.tweets = tweets
                            NSOperationQueue.mainQueue().addOperationWithBlock {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }

    func userHasAccessToTwitter() -> Bool {
        return SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter)
    }

    func translateToEnglish(text: String) {
        self.translator.translate(text) { translation in
            println(String(format: "\"%@\" means \"%@\"", text, translation))
        }
    }


    // MARK: - UITableViewDataSource

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }

    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as UITableViewCell
        let text = self.tweets[indexPath.row].text
        cell.textLabel.text = text
        return cell
    }
}
