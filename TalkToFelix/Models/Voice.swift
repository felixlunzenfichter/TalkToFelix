//
//  Voice.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 14.10.21.
//

import Foundation

class Voice: Identifiable, ObservableObject {
    
    let id = UUID()
    
    let speaker: User
    let recording: Recording
    var listeners: [User]
    
    @Published var listeningEvents: Array<ListeningEvent> = []
    @Published var transcription: Transcription
    
    //  visual representaiton  https://developer.apple.com/documentation/accelerate/visualizing_sound_as_an_audio_spectrogram
    
    init(listeners: [User] = [], recording: Recording, transcription: Transcription = Transcription()) {
        self.speaker = User.thisUser()
        self.listeners = listeners
        self.recording = recording
        self.transcription = transcription
    }
}

extension Voice: Equatable {
    static func == (lhs: Voice, rhs: Voice) -> Bool {
        lhs.id == rhs.id
    }
}

extension Voice {
    static func fixture() -> Voice {
        return Voice(listeners: [.fixture()], recording: .fixture())
    }
}

extension Data {
    static private let goodData = try! Data(contentsOf: .fixture())
    
    static func fixture() -> Data {
        goodData
    }
}

extension URL {
    private static let goodURL = URL(fileURLWithPath: Bundle.main.path(forResource: "good.aac", ofType:nil)!)

    static func fixture() -> URL {
        goodURL
    }
}

struct ListeningEvent: Equatable {
    var isFinal: Bool
    let startTime: Double
    var endTime: Double!
}
