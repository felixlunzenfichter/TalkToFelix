//
//  MyPlayer.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 10.12.21.
//

import Foundation
import AVFAudio

class MyPlayer: Player {
    
    var audioPlayer: AVAudioPlayer!
    
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
