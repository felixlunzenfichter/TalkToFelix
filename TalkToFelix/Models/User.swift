//
//  User.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 14.10.21.
//

import Foundation

class User {

    let id: UUID
    var name: String

    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }

}