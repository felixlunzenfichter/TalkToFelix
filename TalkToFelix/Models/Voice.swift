//
//  Voice.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 14.10.21.
//

import Foundation
import Speech

class Voice: Identifiable, Equatable, ObservableObject {

    let id = UUID()
    
    static func == (lhs: Voice, rhs: Voice) -> Bool {
        lhs.id == rhs.id
    }

    let speaker: User
    var listeners: [User]
    let recording: Recording
    
    @Published var transcription: Transcription

    //  visual representaiton  https://developer.apple.com/documentation/accelerate/visualizing_sound_as_an_audio_spectrogram

    init(listeners: [User] = [], recording: Recording = Recording(audioData: Data(), length: 0.0), transcription: Transcription = Transcription()) {
        self.speaker = ThisUser()
        self.listeners = listeners
        self.recording = recording
        self.transcription = transcription
    }
}

extension Voice {
    static func fixture() -> Voice {
        return Voice(listeners: [.fixture()], recording: .init(audioData: .fixture(), length: 69))
    }
}

extension Data {
    static let fixtureData = "00001111"

    static func fixture() -> Data {
        return Data(base64Encoded: fixtureData)!
    }
}

class Transcription {
    
    internal init(isFinal: Bool = false, sftranscription: SFTranscription = SFTranscription()) {
        self.isFinal = isFinal
        self.sftranscription = sftranscription
    }
    
    var isFinal: Bool = false
    
    public var transcript: String {
        sftranscription.formattedString
    }

    public var sftranscription: SFTranscription
}


