//
//  AudioPlayer.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 10.12.21.
//

import Foundation
import AVFAudio

protocol Player {
    func play()
    func pause()
    init(data: Data) 
}
