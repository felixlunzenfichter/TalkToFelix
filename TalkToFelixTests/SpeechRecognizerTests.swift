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
    
    var cancellables = Set<AnyCancellable>()
    
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

    
    func testOneTranscription() {}
    func testTwoTranscriptions() {}
    func testThreeConcurrentTranscriptions() {
        
    }
    
}
