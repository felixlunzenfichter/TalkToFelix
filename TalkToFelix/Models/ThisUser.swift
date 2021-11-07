//
//  ThisUser.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 14.10.21.
//

import Foundation

// Singleton class representing the current user.
class ThisUser: User {

    init() {
        super.init(name: "Felix")
    }

}
