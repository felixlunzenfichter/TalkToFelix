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
    
    func testShowListeningProgress() {
        let expectation = XCTestExpectation(description: "Expected to see listening progress.")
        let voice = Voice.fixture()
        let viewModel = VoiceView.ViewModel(voice: voice)
        let conversationViewModel = ConversationView.ViewModel.fixture()
        
//        let frameDuration = 0.1
//        let startTime = 0.5
//        let duration = 2.5
//        let values = [Double](repeating: 0.2, count: 20)
        
        var time = 0.0
        viewModel.$voicingGraphData.sink { voicingGraphData in
            defer {time += 0.1}
            let i = 0
            voicingGraphData.map { element in
                if (element.time < time) {
                    XCTAssert(element.listeningState == ListeningState.hasBeenListenedTo)
                } else if (element.time == time) {
                    XCTAssert(element.listeningState == ListeningState.isBeingListenedTo)
                } else {
                    XCTAssert(element.listeningState == ListeningState.hasNotBeenListenedTo, "Received: \(element) at time \(time)")
                }
            }
            if (time == 2.6) {
                expectation.fulfill()
            }
        }.store(in: &cancellables)
        
        viewModel.$transcriptIsFinal.sink {
            if($0) {
                conversationViewModel.listenTo(voice: voice)
            }
        }.store(in: &cancellables)
        
        MySpeechRecognizer.transcribe(voice: voice)
        
        wait(for: [expectation], timeout: 800)
    }
}

