//
//  RecorderTests.swift
//  TalkToFelixTests
//
//  Created by Felix Lunzenfichter on 04.12.21.
//

import XCTest
@testable import TalkToFelix

class RecorderTests: XCTestCase {
    
    let halfASecond: UInt32 = 500000
    
    func testLengthOfRecordingIsZeroAtStart() {
        let recorder: Recorder = MyRecorder()
        XCTAssertEqual(recorder.length, 0)
    }
    
    func testRecordForHalfASecond() {
        let recorder: Recorder = MyRecorder()
        
        recorder.start()
        usleep(halfASecond)
        let recordingLength = recorder.length
        
        XCTAssertGreaterThan(recordingLength, 0.4)
        XCTAssertLessThan(recordingLength, 0.6)
    }
    
    func testRecordThenStopThenRecordForHalfASecond() {
        let recorder: Recorder = MyRecorder()
        
        recorder.start()
        usleep(halfASecond)
        recorder.stop()
        recorder.start()
        usleep(halfASecond)
        let recordingLength = recorder.length
        
        XCTAssertGreaterThan(recordingLength, 0.4)
        XCTAssertLessThan(recordingLength, 0.6)
    }
    
    override class func tearDown() {
        let recorder = MyRecorder()
        let filename = recorder.audioFilename
        try? FileManager.default.removeItem(atPath: filename.path)
        
    }
    override func setUp() {
        let recorder = MyRecorder()
        let filename = recorder.audioFilename
        try? FileManager.default.removeItem(atPath: filename.path)
    }
    
}
