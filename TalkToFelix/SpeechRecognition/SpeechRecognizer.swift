//
//  Transcription.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 19.06.22.
//

import Foundation

protocol SpeechRecognizer {
    var voiceToBeTranscribed: Voice { get }
    init(voice: Voice)
    func finalize() 
}
