//
//  TwitterUser.swift
//  Spreken
//
//  Created by Ayaka Nonaka on 10/29/14.
//  Copyright (c) 2014 Ayaka Nonaka. All rights reserved.
//

import Foundation

class TwitterUser {

    let name: String
    let username: String
    let profileImageURL: NSURL

    init(name: String, username: String, profileImageURL: NSURL) {
        self.name = name
        self.username = username
        self.profileImageURL = profileImageURL
    }
}
