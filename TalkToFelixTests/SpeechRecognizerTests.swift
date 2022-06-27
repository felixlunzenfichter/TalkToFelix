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

final class SpeechRecognizerTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    private let good = URL(fileURLWithPath: Bundle.main.path(forResource: "good.aac", ofType:nil)!)
    
    func testEmptyTranscripton() {
        
        // Arrange
        let expectation = XCTestExpectation(description: "Expected empty voice to give an empty transcrition")

        var round = 0
        var isFinalValue: Bool {
            switch round {
            case 0:
                return false
            default:
                return true
            }
        }
        
        let voice = Voice()
        voice.$transcription.sink { value in
            defer {round+=1}
            print("Received value: \(value)")
            guard case let transcription: Transcription  = value else {
                return XCTFail("Expected a successful Result, got: \(value)")
            }
            XCTAssertEqual(transcription.isFinal, isFinalValue)
            XCTAssert(transcription.transcript == "")
            if isFinalValue {expectation.fulfill()}
        }.store(in: &cancellables)
        
        // Act
        let speechRecognizer: SpeechRecognizer = MySpeechRecognizer(voice: voice)
        speechRecognizer.finalize()
        
        // Assert
        wait(for: [expectation], timeout: 5.0)
    }
    
    fileprivate func checkGoodTranscript(_ transcription: Published<Transcription>.Publisher.Output, expectation: XCTestExpectation) {
        if (!transcription.isFinal) {
            XCTAssert(transcription.transcript == "" || transcription.transcript == "Could")
        } else {
            XCTAssert(transcription.transcript == "Could")
            expectation.fulfill()
        }
    }
    
    func testOneTranscription() {
        let expectation = XCTestExpectation(description: "Expected a transcription")
        
        let voice = Voice(recording: Recording(url: good))
        
        voice.$transcription.sink {transcription in
            self.checkGoodTranscript(transcription, expectation: expectation)
        }.store(in: &cancellables)
        
        let speechRecognizer: SpeechRecognizer = MySpeechRecognizer()
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
            if (!transcription.isFinal) {
                XCTAssert(transcription.transcript == "" || transcription.transcript == "Could")
            } else {
                XCTAssert(transcription.transcript == "Could")
                expectation.fulfill()
                speechRecognizer.transcribe(voice: voice2)
            }
            
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
    
}
