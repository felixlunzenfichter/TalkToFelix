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

let goodURL = URL(fileURLWithPath: Bundle.main.path(forResource: "good.aac", ofType:nil)!)
let goodData = try! Data(contentsOf: goodURL)

let oneSecond: UInt32 = 1000000
let halfASecond: UInt32 = 500000
let OneTenthOfASecond: UInt32 = 100000
let precision: Double = 0.1


