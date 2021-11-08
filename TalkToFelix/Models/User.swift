//
//  User.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 14.10.21.
//

import Foundation

class User {
    
    let id = UUID()
    
    var name: String

    init(name: String) {
        self.name = name
    }

}

extension User {
    static func fixture() -> User {
        return User(name: "Carli <3")
    }
}
