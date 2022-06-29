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
}
