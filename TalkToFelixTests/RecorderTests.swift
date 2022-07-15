//
//  RecorderTests.swift
//  TalkToFelixTests
//
//  Created by Felix Lunzenfichter on 04.12.21.
//

import XCTest
@testable import TalkToFelix

class RecorderTests: XCTestCase {
    

    
    func testLengthOfRecordingIsZeroAtStart() {
        let recorder: Recorder = MyRecorder()
        XCTAssertEqual(recorder.getRecording().length, 0)
    }
    
    func testRecordForHalfASecond() {
        let recorder: Recorder = MyRecorder()
        let recordingExpectedLength = 0.5
        
        recorder.start()
        usleep(halfASecond)
        let recordingLength = recorder.getRecording().length
        
        XCTAssertGreaterThan(recordingLength, recordingExpectedLength - precision)
        XCTAssertLessThan(recordingLength, recordingExpectedLength + precision)
    }
    
    func testRecordForHalfASecondThenPause() {
        let recorder: Recorder = MyRecorder()
        let recordingExpectedLength = 0.5
        
        recorder.start()
        usleep(halfASecond)
        recorder.pause()
        let recordingLength = recorder.getRecording().length
        
        XCTAssertGreaterThan(recordingLength, recordingExpectedLength - precision)
        XCTAssertLessThan(recordingLength, recordingExpectedLength + precision)
    }
    
    func testRecordForAQuarterSecondThenStopThenRecordForHalfASecond() {
        let recorder: Recorder = MyRecorder()
        let firstRecordingExpectedLength = 0.25
        let secondRecorgingExpectedLength = 0.5
        
        recorder.start()
        usleep(halfASecond/2)
        let firstRecordingLength = recorder.getRecording().length
        recorder.stop()
        
        recorder.start()
        usleep(halfASecond)
        let secondRecordingLength = recorder.getRecording().length
        recorder.stop()
                
        XCTAssertGreaterThan(firstRecordingLength, firstRecordingExpectedLength - precision)
        XCTAssertLessThan(firstRecordingLength, firstRecordingExpectedLength + precision)
        
        XCTAssertGreaterThan(secondRecordingLength, secondRecorgingExpectedLength - precision)
        XCTAssertLessThan(secondRecordingLength, secondRecorgingExpectedLength + precision)
    }
    
    func testAudioDataIsEmptyAfterInitialization() {
        let recorder: Recorder = MyRecorder()
        let data = recorder.getRecording().audioData
        XCTAssertEqual(Data(), data)
    }
    
    func testAudioDataIsNotEmptyAfterRecording() {
        let recorder: Recorder = MyRecorder()
        recorder.start()
        usleep(OneTenthOfASecond)
        let data = recorder.getRecording().audioData
        
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
