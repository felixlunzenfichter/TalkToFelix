//
//  TranscriptionTests.swift
//  TalkToFelixTests
//
//  Created by Felix Lunzenfichter on 18.06.22.
//

import Combine
import XCTest
@testable import TalkToFelix
import Speech

// Apples speech recoginition service requieres an active internet connection. Tests should not require an internet connection but we
// will make an exception here. 

final class SpeechRecognizerTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    let good = URL(fileURLWithPath: Bundle.main.path(forResource: "good.aac", ofType:nil)!)
    
    func testOneTranscription() {
        let expectation = XCTestExpectation(description: "Expected a transcription")
        let voice = Voice(recording: Recording(url: good))
        let speechRecognizer: SpeechRecognizer = MySpeechRecognizer()
        voice.$transcription.sink {transcription in
            self.checkGoodTranscript(transcription, expectation: expectation)
        }.store(in: &cancellables)
        
        speechRecognizer.transcribe(voice: voice)
        
        wait(for: [expectation], timeout: 5)
        
    }
    
    func testTwoSubsequentTranscriptions() {
        
        let expectation = XCTestExpectation(description: "Expected a first transcription")
        let expectation2 = XCTestExpectation(description: "Expected a second transcription")
        
        let voice = Voice(recording: Recording(url: good))
        let voice2 = Voice(recording: Recording(url: good))
        
        let speechRecognizer: SpeechRecognizer = MySpeechRecognizer()
        
        voice.$transcription.sink {transcription in
            self.checkGoodTranscript(transcription, expectation: expectation)
            speechRecognizer.transcribe(voice: voice2)
        }.store(in: &cancellables)
        
        voice2.$transcription.sink {transcription in
            self.checkGoodTranscript(transcription, expectation: expectation2)
        }.store(in: &cancellables)
        
        speechRecognizer.transcribe(voice: voice)
        
        wait(for: [expectation, expectation2], timeout: 5)
    }
    
    func testTwoConcurrentTranscriptions() {
        let expectation = XCTestExpectation(description: "Expected a concurrent transcription")
        let expectation2 = XCTestExpectation(description: "Expected a concurrent transcription")
        
        let voice = Voice(recording: Recording(url: good))
        let voice2 = Voice(recording: Recording(url: good))
        
        voice.$transcription.sink {transcription in
            self.checkGoodTranscript(transcription, expectation: expectation)
        }.store(in: &cancellables)
        
        voice2.$transcription.sink {transcription in
            self.checkGoodTranscript(transcription, expectation: expectation2)
        }.store(in: &cancellables)
        
        let speechRecognizer: SpeechRecognizer = MySpeechRecognizer()
        speechRecognizer.transcribe(voice: voice)
        speechRecognizer.transcribe(voice: voice2)
        
        wait(for: [expectation, expectation2], timeout: 5)
    }
    
    fileprivate func checkGoodTranscript(_ transcription: Transcription, expectation: XCTestExpectation) {
        if (!transcription.isFinal) {
            XCTAssert(transcription.transcript == "" || transcription.transcript == "Could")
        } else {
            XCTAssert(transcription.transcript == "Could")
            expectation.fulfill()
        }
    }
    
    func testGetVoicingStartTime() {
        let expectation = XCTestExpectation(description: "Expected voice to be recognized between 2 and 2.2 seconds into the audio.")
        let voice = Voice(recording: Recording(url: good))
        
        voice.$transcription.sink {
            transcription in
            if (!transcription.isFinal) {return}
            let startTime = transcription.startTime
            XCTAssert(startTime > 2 && startTime < 2.2)
            expectation.fulfill()
        }.store(in: &cancellables)
        
        let speechRecognizer: SpeechRecognizer = MySpeechRecognizer()
        speechRecognizer.transcribe(voice: voice)
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testGetVoicingValues() {
        let expectation = XCTestExpectation(description: "Expected voicing to describe a timeframe with a length between 0.4 and 0.5 seconds.")
        let voice = Voice(recording: Recording(url: good))
        
        voice.$transcription.sink {
            transcription in
            if (!transcription.isFinal) {return}
            let voicing: Voicing = transcription.voicing
            let values : [Double] = voicing.values
            let frameDuration: Double = voicing.frameDuration
            let length = Double(values.count) * frameDuration
            XCTAssert(0.4 < length && length < 0.5)
            expectation.fulfill()
        }.store(in: &cancellables)
        
        let speechRecognizer: SpeechRecognizer = MySpeechRecognizer()
        speechRecognizer.transcribe(voice: voice)
        
        wait(for: [expectation], timeout: 5)
    }
}
