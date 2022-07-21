//
//  Transcription.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 19.06.22.
//

import Foundation

protocol SpeechRecognizer {
    static func transcribe(voice: Voice)
}
