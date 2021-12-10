//
//  Recorder.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 05.12.21.
//

import Foundation

protocol Recorder {
    var length: Double {get}
    func start()
    func stop() -> Data
}
