//
//  PlayerTests.swift
//  TalkToFelixTests
//
//  Created by Felix Lunzenfichter on 10.12.21.
//

import XCTest
@testable import TalkToFelix

class PlayerTests: XCTestCase {
    
    
    func testInitializePlayer() {
        let _: Player = MyPlayer(data: goodData)
    }
    
    func testPlayAudio() {
        let player: Player = MyPlayer(data: goodData)
        
        player.play()
        usleep((1/50) * oneSecond)
    }
    
    func testPlayPausePlay() {
        var player: Player = MyPlayer(data: goodData)

        player.play()
        usleep((1/100) * oneSecond)
        player.pause()
        player.play()
        usleep((1/100) * oneSecond)
        player.pause()
        
        player.currentTime = 2
        player.play()
        usleep(oneSecond)
    }
}
