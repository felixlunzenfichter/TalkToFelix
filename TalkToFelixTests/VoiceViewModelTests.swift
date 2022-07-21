//
//  VoiceViewModelTests.swift
//  TalkToFelixTests
//
//  Created by Felix Lunzenfichter on 19.07.22.
//

import XCTest
import Combine
@testable import TalkToFelix

final class VoiceViewModelTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    
    func testInitializeVoiceViewModel() {
        let voice = Voice.fixture()
        let viewModel: VoiceView.ViewModel = VoiceView.ViewModel(voice: voice)
        XCTAssert(viewModel.duration == 69)
        XCTAssert(viewModel.transcript == "")
        XCTAssert(viewModel.transcriptIsFinal == false)
    }
    
    func testVoiceViewModelTranscriptionUpdate() {
        let transcriptionExpectation = XCTestExpectation(description:"Expected transcription to be displayed.")
        let transcriptionIsFinalExpectation = XCTestExpectation(description: "Expected transcription to be final at last.")
        let voice = Voice.fixture()
        let viewModel = VoiceView.ViewModel(voice: voice)
        
        var transcriptionRound: Int = 0
        viewModel.$transcript.sink { transcription in
            transcriptionRound += 1
            switch (transcriptionRound) {
            case 1: XCTAssert(transcription == "")
            case 2: XCTAssert(transcription == "Could")
            case 3: XCTAssert(transcription == "Could"); transcriptionExpectation.fulfill()
            default: XCTFail()
            }
        }.store(in: &cancellables)
        
        var transcriptionIsFinalRound = 0
        viewModel.$transcriptIsFinal.sink { isFinal in
            transcriptionIsFinalRound += 1
            switch (transcriptionIsFinalRound) {
            case 1: XCTAssert(!isFinal)
            case 2: XCTAssert(!isFinal)
            case 3: XCTAssert(isFinal); transcriptionIsFinalExpectation.fulfill()
            default: XCTFail()
            }
        }.store(in: &cancellables)
        
        MySpeechRecognizer.transcribe(voice: voice)
        
        wait(for: [transcriptionExpectation, transcriptionIsFinalExpectation], timeout: 500.0)
    }
}

