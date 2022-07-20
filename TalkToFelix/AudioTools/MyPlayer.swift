//
//  MyPlayer.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 10.12.21.
//

import Foundation
import AVFAudio

class MyPlayer: NSObject, AVAudioPlayerDelegate, Player {
    
    var duration: Double {
        return audioPlayer.duration
    }
    var currentTime: Double {
        get {
            return audioPlayer.currentTime
        }
        set(newValue) {
            audioPlayer.currentTime = newValue
        }
    }
    var didFinishPlayingCallback: () -> Void
    private var audioPlayer: AVAudioPlayer!
    
    required init(data: Data) {
        audioPlayer = try! AVAudioPlayer(data: data)
        didFinishPlayingCallback = {}
    }
    
    func play(didFinishPlayingCallback: @escaping () -> Void = {}) {
        audioPlayer.delegate = self
        self.didFinishPlayingCallback = didFinishPlayingCallback
        try! AVAudioSession.sharedInstance().setCategory(.playback)
        try! AVAudioSession.sharedInstance().setActive(true)
        audioPlayer.play()
    }
    
    func pause() {
        audioPlayer.pause()
    }
   
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        didFinishPlayingCallback()
    }
}
