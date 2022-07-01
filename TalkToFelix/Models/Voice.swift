//
//  Voice.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 14.10.21.
//

import Foundation
import Speech

class Voice: Identifiable, ObservableObject {
    
    let id = UUID()
    
    let speaker: User
    let recording: Recording
    var listeners: [User]
    
    @Published var transcription: Transcription
    
    //  visual representaiton  https://developer.apple.com/documentation/accelerate/visualizing_sound_as_an_audio_spectrogram
    
    init(listeners: [User] = [], recording: Recording = Recording(audioData: Data(), length: 0.0), transcription: Transcription = Transcription()) {
        self.speaker = User.thisUser()
        self.listeners = listeners
        self.recording = recording
        self.transcription = transcription
    }
}

extension Voice: Equatable {
    static func == (lhs: Voice, rhs: Voice) -> Bool {
        lhs.id == rhs.id
    }}

extension Voice {
    static func fixture() -> Voice {
        return Voice(listeners: [.fixture()], recording: .fixture())
    }
}

extension Data {
    static private let fixtureData = try! Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "good.aac", ofType:nil)!))
    
    static func fixture() -> Data {
        return fixtureData
    }
}

struct Transcription {
    
    internal let isFinal: Bool
    internal var transcript: String {
        sftranscription.formattedString
    }
    
    private let sftranscription: SFTranscription
    
    internal init(isFinal: Bool = false, sftranscription: SFTranscription = SFTranscription()) {
        self.isFinal = isFinal
        self.sftranscription = sftranscription
    }
}


