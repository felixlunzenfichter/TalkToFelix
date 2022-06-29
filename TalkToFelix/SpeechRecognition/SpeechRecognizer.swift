//
//  Transcription.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 19.06.22.
//

import Foundation

protocol SpeechRecognizer {
    func transcribe(voice: Voice)
}
