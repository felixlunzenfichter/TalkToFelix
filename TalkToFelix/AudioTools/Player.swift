//
//  AudioPlayer.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 10.12.21.
//

import Foundation
import AVFAudio

protocol Player {
    var currentTime: Double { get set }
    func play(didFinishPlayingCallback: @escaping () -> Void)
    func pause()
    init(data: Data)
}

extension Player {
    func play(didFinishPlayingCallback: @escaping () -> Void = {}) {
        play(didFinishPlayingCallback: didFinishPlayingCallback)
    }
}
