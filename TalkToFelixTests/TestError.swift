//
//  TestError.swift
//  TalkToFelixTests
//
//  Created by Felix Lunzenfichter on 09.11.21.
//

import Foundation

struct TestError: Equatable, Error {
    let id : UUID = UUID()
}
