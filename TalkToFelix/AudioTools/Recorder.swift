//
//  Recorder.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 05.12.21.
//

import Foundation

protocol Recorder {
    func start()
    func pause()
    func stop()
    func getRecording() -> Recording
}
