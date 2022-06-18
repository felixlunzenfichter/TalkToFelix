//
//  ExceptionHandling.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 18.06.22.
//

import Foundation

infix operator ~>

func ~><T>(expression: @autoclosure () throws -> T, error: Error) -> T? {
    do {
        return try expression()
    } catch {
        handle(error: error)
    }
    return nil
}

func handle(error: Error) {}

enum DatabaseError: Error {
    case failedToGetVoices
}

enum RecorderError: Error {
    case getData
    case start
    case initialize
}




