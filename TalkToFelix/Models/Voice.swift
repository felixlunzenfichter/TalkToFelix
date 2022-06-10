//
//  Voice.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 14.10.21.
//

import Foundation

struct Voice: Identifiable, Equatable {

    static func == (lhs: Voice, rhs: Voice) -> Bool {
        lhs.id == rhs.id
    }

    let id = UUID()

    let speaker: User
    let listener: User
    let recording: Recording
    let transcript: String?

    //  visual representaiton  https://developer.apple.com/documentation/accelerate/visualizing_sound_as_an_audio_spectrogram

}

extension Voice {
    static func fixture() -> Voice {
        return Voice(speaker: .fixture(), listener: .fixture(), recording: .init(audioData: .fixture(), length: 69), transcript: "hi")
    }
}

extension Data {
    static let fixtureData = "00001111"

    static func fixture() -> Data {
        return Data(base64Encoded: fixtureData)!
    }
}

