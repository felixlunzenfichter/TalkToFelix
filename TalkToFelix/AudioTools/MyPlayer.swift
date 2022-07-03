//
//  MyPlayer.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 10.12.21.
//

import Foundation
import AVFAudio

class MyPlayer: Player {
    
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
    
    private var audioPlayer: AVAudioPlayer!
    
    func play() {
        try! AVAudioSession.sharedInstance().setCategory(.playback)
        try! AVAudioSession.sharedInstance().setActive(true)
        audioPlayer.play()
    }
    
    func pause() {
        audioPlayer.pause()
    }
    
    required init(data: Data) {
        audioPlayer = try! AVAudioPlayer(data: data)
    }
    
}
