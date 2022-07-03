//
//  PlayerTests.swift
//  TalkToFelixTests
//
//  Created by Felix Lunzenfichter on 10.12.21.
//

import XCTest
@testable import TalkToFelix

class PlayerTests: XCTestCase {
    
    let oneSecond: UInt32 = 1000000
    
    let data = try! Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "good.aac", ofType:nil)!))
    
    func testInitializePlayer() {
        let _: Player = MyPlayer(data: data)
    }
    
    func testPlayAudio() {
        let player: Player = MyPlayer(data: data)
        
        player.play()
        usleep((1/50) * oneSecond)
    }
    
    func testPlayPausePlay() {
        let player: MyPlayer = MyPlayer(data: data)

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
