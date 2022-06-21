//
//  MyTranscription.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 19.06.22.
//

import Foundation

class MySpeechRecognizer: SpeechRecognizer {
    
    let voiceToBeTranscribed: Voice
    
    required init(voice: Voice) {
        voiceToBeTranscribed = voice
    }
    
    func finalize() {
        voiceToBeTranscribed.transcription = Transcription(isFinal: true)
    }
}
