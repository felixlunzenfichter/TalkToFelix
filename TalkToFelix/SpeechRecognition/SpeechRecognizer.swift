//
//  File.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 10.06.22.
//

import Foundation

protocol SpeechRecognizer {
    var transcript: String { get }
    func transcribe()
    func stopTranscribing()
    func reset()
}

