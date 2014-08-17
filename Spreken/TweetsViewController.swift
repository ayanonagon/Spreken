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

class TweetsViewController: UITableViewController {

    let accountStore: ACAccountStore;
    let translator: Polyglot

    required init(coder aDecoder: NSCoder!) {
        accountStore = ACAccountStore()
        translator = Polyglot(clientId: "", clientSecret: "")
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        var english = "Hallo wereld"
        self.translateToEnglish("Hallo wereld")

        if (self.userHasAccessToTwitter()) {
            let twitterAccountType = self.accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
            self.accountStore.requestAccessToAccountsWithType(twitterAccountType, options: nil) {
                granted, error in
                if granted {
                    let twitterAccounts = self.accountStore.accountsWithAccountType(twitterAccountType)
                    if twitterAccounts.count == 0 {
                        let alertView = UIAlertView(title: "No Twitter accounts found", message: "Please add a Twitter account in Settings.",
                                                    delegate: nil, cancelButtonTitle: "OK")
                        alertView.show()
                    } else {
                        let twitterAccount = twitterAccounts[0] as ACAccount
                        // TODO: Do something with this account.
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
}
