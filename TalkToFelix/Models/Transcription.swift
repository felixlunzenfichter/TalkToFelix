//
//  Transcript.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 13.07.22.
//

import Foundation
import Speech

struct Transcription {
    internal let isFinal: Bool
    private let result: SFSpeechRecognitionResult
    
    internal init(isFinal: Bool = false, result: SFSpeechRecognitionResult = SFSpeechRecognitionResult()) {
        self.isFinal = isFinal
        self.result = result
    }
}

extension Transcription {
    internal var transcript: String {
        sftranscription.formattedString
    }
    internal var startTime : Double {
        sftranscription.segments.first!.timestamp
    }
    internal var voicing: Voicing {
        Voicing(frameDuration: (sfSpeechRegognitionMetaData.voiceAnalytics?.voicing.frameDuration) ?? 1, values: (sfSpeechRegognitionMetaData.voiceAnalytics?.voicing.acousticFeatureValuePerFrame) ?? [] )
    }
    private var sftranscription: SFTranscription {
        result.bestTranscription
    }
    private var sfSpeechRegognitionMetaData: SFSpeechRecognitionMetadata {
        result.speechRecognitionMetadata ?? SFSpeechRecognitionMetadata()
    }
}

struct Voicing {
    let frameDuration: Double
    let values: [Double]
}
