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
    let OneTenthOfASecond: UInt32 = 100000
    let precision: Double = 0.1
    
    func testLengthOfRecordingIsZeroAtStart() {
        let recorder: Recorder = MyRecorder()
        XCTAssertEqual(recorder.length, 0)
    }
    
    func testRecordForHalfASecond() {
        let recorder: Recorder = MyRecorder()
        let recordingExpectedLength = 0.5
        
        recorder.start()
        usleep(halfASecond)
        let recordingLength = recorder.length
        
        XCTAssertGreaterThan(recordingLength, recordingExpectedLength - precision)
        XCTAssertLessThan(recordingLength, recordingExpectedLength + precision)
    }
    
    func testRecordForAQuarterSecondThenStopThenRecordForHalfASecond() {
        let recorder: Recorder = MyRecorder()
        let firstRecordingExpectedLength = 0.25
        let secondRecorgingExpectedLength = 0.5
        
        recorder.start()
        usleep(halfASecond/2)
        let firstRecordingLength = recorder.length
        _ = recorder.stop()
        
        recorder.start()
        usleep(halfASecond)
        let secondRecordingLength = recorder.length
        _ = recorder.stop()
                
        XCTAssertGreaterThan(firstRecordingLength, firstRecordingExpectedLength - precision)
        XCTAssertLessThan(firstRecordingLength, firstRecordingExpectedLength + precision)
        
        XCTAssertGreaterThan(secondRecordingLength, secondRecorgingExpectedLength - precision)
        XCTAssertLessThan(secondRecordingLength, secondRecorgingExpectedLength + precision)
    }
    
    func testAudioDataIsEmptyAfterInitialization() {
        let recorder: Recorder = MyRecorder()
        let data = recorder.stop()
        XCTAssertEqual(Data(), data)
    }
    
    func testAudioDataIsNotEmptyAfterRecording() {
        let recorder: Recorder = MyRecorder()
        recorder.start()
        usleep(OneTenthOfASecond)
        let data = recorder.stop()
        
        XCTAssertNotEqual(Data(), data)
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
