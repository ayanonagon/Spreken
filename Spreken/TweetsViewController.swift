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

class TweetsViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate {

    let accountStore: ACAccountStore
    var accounts: Array<ACAccount>
    var account: ACAccount?

    let translator: Polyglot

    var tweets: Array<Tweet>

    required init(coder aDecoder: NSCoder!) {
        accountStore = ACAccountStore()
        accounts = []
        translator = Polyglot(clientId: "", clientSecret: "")
        tweets = []
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.registerNib(UINib(nibName: "TweetTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "TweetTableViewCell");
        self.tableView.rowHeight = 100.0;

        if (self.userHasAccessToTwitter()) {
            let twitterAccountType = self.accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
            self.accountStore.requestAccessToAccountsWithType(twitterAccountType, options: nil) {
                granted, error in
                if granted {
                    let twitterAccounts = self.accountStore.accountsWithAccountType(twitterAccountType) as Array<ACAccount>
                    if twitterAccounts.count == 0 {
                        let alertView = UIAlertView(title: "No Twitter accounts found",
                                                    message: "Please add a Twitter account in Settings.",
                                                    delegate: nil, cancelButtonTitle: "OK")
                        alertView.show()
                    } else if twitterAccounts.count == 1 {
                        self.account = twitterAccounts[0] as ACAccount
                        self.reloadFeed()
                    } else {
                        self.accounts = twitterAccounts
                        self.presentAccountPicker(twitterAccounts)
                    }
                }
            }
        }
    }

    func userHasAccessToTwitter() -> Bool {
        return SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter)
    }

    func presentAccountPicker(accounts: Array<ACAccount>) {
        let accountPickerSheet = UIActionSheet(title: "Please choose an account", delegate: self, cancelButtonTitle: nil, destructiveButtonTitle: nil)
        for twitterAccount in accounts {
            accountPickerSheet.addButtonWithTitle(twitterAccount.username)
        }
        NSOperationQueue.mainQueue().addOperationWithBlock {
            accountPickerSheet.showInView(self.view)
        }
    }

    func reloadFeed() {
        Tweet.fetchAll(self.account!) { tweets in
            self.tweets = tweets
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.tableView.reloadData()
            }
        }
    }


    // MARK: - UIActionSheetDelegate

    func actionSheet(actionSheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int) {
        self.account = self.accounts[buttonIndex]
        self.reloadFeed()
    }


    // MARK: - UITableViewDataSource

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }

    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell: TweetTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("TweetTableViewCell", forIndexPath: indexPath) as TweetTableViewCell
        let text = self.tweets[indexPath.row].text
        cell.tweetTextLabel.text = text
        return cell
    }


    // MARK: - UITableViewDelegate

    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        let tweet = self.tweets[indexPath.row]
        self.translator.translate(tweet.text) { translation in
            println(translation)
        }
    }
}
