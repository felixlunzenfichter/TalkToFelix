//
//  Voice.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 14.10.21.
//

import Foundation

class Voice: Identifiable, Equatable, ObservableObject {

    let id = UUID()
    
    static func == (lhs: Voice, rhs: Voice) -> Bool {
        lhs.id == rhs.id
    }

    let speaker: User
    var listeners: [User]
    let recording: Recording

    //  visual representaiton  https://developer.apple.com/documentation/accelerate/visualizing_sound_as_an_audio_spectrogram

    init(listeners: [User] = [], recording: Recording = Recording(audioData: Data(), length: 0.0)) {
        self.speaker = ThisUser()
        self.listeners = listeners
        self.recording = recording
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

