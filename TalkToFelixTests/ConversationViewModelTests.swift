//
//  ConversationViewModelTests.swift
//  TalkToFelixTests
//
//  Created by Felix Lunzenfichter on 07.11.21.
//

import XCTest
@testable import TalkToFelix
import Combine

@available(iOS 15.0.0, *) class ConversationViewModelTests: XCTestCase {
    
    let halfASecond: UInt32 = 500000
    let OneTenthOfASecond: UInt32 = 100000
    let precision: Double = 0.1
    
    private var cancellables = Set<AnyCancellable>()
    
    func testWhenViewModelIsIniaitlizedPublishesEmptyVoices() {
        let viewModel = ConversationView.ViewModel.fixture()
        
        XCTAssertEqual(try viewModel.voices.get(), [Voice]())
    }
    
    func testVoicesAreBeingFetchedSuccessfully() {
        
        // Arrange the ViewModel and its data source
        let firstExpectedResult: [Voice] = [Voice]()
        let secondExpectedResult: [Voice] = [Voice.fixture()]
        
        let mockDatabase = MockDatabase(returning: .success(secondExpectedResult))
        let viewModel = ConversationView.ViewModel(database: mockDatabase)
        
        let expectation = XCTestExpectation(description: "Publishes expected voices successfully")
        var expectedResult = firstExpectedResult
        
        // Act on the ViewModel to trigger the update
        viewModel.$voices.sink {value in
            guard case .success(let voices) = value else {
                return XCTFail("Expected a successful Result, got: \(value)")
            }
            
            XCTAssertEqual(expectedResult, voices)
            if (voices == firstExpectedResult) {
                expectedResult = secondExpectedResult
            } else {
                expectation.fulfill()
            }
        }.store(in: &cancellables)
        
        // Assert the expected behavior
        wait(for: [expectation], timeout: 1)
    }
    
    func testWhenVoicesFetchingFailsPublishesError() {
        let expectation = XCTestExpectation(description: "Publishes an error")
        
        let expectedError = TestError()
        let mockDatabase = MockDatabase(returning: .failure(expectedError))
        let viewModel = ConversationView.ViewModel(database: mockDatabase)
        
        viewModel.$voices.dropFirst().sink {value in
            guard case .failure(let error) = value else {
                return XCTFail("Expected a failing result but got \(value)")
            }
            
            XCTAssertEqual(expectedError, error as? TestError)
            expectation.fulfill()
            
        }.store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
        
    }
    
    func testStateTransitionToAndFromRecordingState() async {
        let viewModel = ConversationView.ViewModel.fixture()
        
        XCTAssert(!viewModel.isRecording)
        
        viewModel.recordButtonClicked()
        
        XCTAssert(viewModel.isRecording)
        
        viewModel.recordButtonClicked()
        
        XCTAssert(!viewModel.isRecording)
    }
    
    
    func testStopRecordingAddsAVoiceToTheConversation() async {
        let initialVoiceInChat = [Voice.fixture()]
        let viewModel = ConversationView.ViewModel(database: MockDatabase(returning: .success(initialVoiceInChat)))
        
        let expectation = XCTestExpectation(description: "Expected 2 voices in the conversation")
        
        try! await Task.sleep(nanoseconds: 1 * NSEC_PER_SEC)
        
        viewModel.recordButtonClicked()
        viewModel.recordButtonClicked()
        
        viewModel.$voices.sink {value in
            guard case .success(let voices) = value else {
                return XCTFail("Expected 2 successfully delivered voices but got \(value)")
            }
            
            XCTAssertEqual(voices.count, 2)
            expectation.fulfill()
            
        }.store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.5)
    }
    
    func testRecordingLengthIsZeroAtStart() {
        let viewModel = ConversationView.ViewModel.fixture()
        let length: Double = viewModel.recordingLength
        XCTAssertEqual(length, 0)
    }
    
    func testRecordingLengthUpdatesAfterOneTenthOfASecond() {
        
        // Arrange
        let viewModel = ConversationView.ViewModel.fixture()
        var round: Double = 0
        let expectation = XCTestExpectation(description: "recordinglength is published once every 0.1 seconds")
        viewModel.$recordingLength.sink() {value in
            defer {round += 1}
            
            XCTAssertEqual(value, round / 10)
            print(value)
            
            if (round == 3.0) {
                expectation.fulfill()
                self.cancellables.removeAll()
            }
        }.store(in: &cancellables)
        
        // Act
        viewModel.recordButtonClicked()
        
        // Assert
        wait(for: [expectation], timeout: 0.35)
    }
    
    func testRecordingLengthIsZeroAgainAfterSending() {
        
        let viewModel = ConversationView.ViewModel.fixture()
        var round: Double = 0
        let expectation = XCTestExpectation(description: "Length of current recording is zero after sending.")
        viewModel.$recordingLength.sink() {value in
            defer {round += 1}
            if (round == 2.0) {
                XCTAssertEqual(value, 0.0)
                expectation.fulfill()
            }
        }.store(in: &cancellables)
        
        viewModel.recordButtonClicked()
        Timer.scheduledTimer(withTimeInterval: 0.15, repeats: false) {_ in
            viewModel.recordButtonClicked()
        }
        
        wait(for: [expectation], timeout: 0.3)
    }
    
    func testRecordAndPlay() {
        let expectation = XCTestExpectation(description: "Player starts.")
        let firstExpectedResult: [Voice] = [Voice]()
        let secondExpectedResult: [Voice] = [Voice.fixture()]
        
        let mockDatabase = MockDatabase(returning: .success(secondExpectedResult))
        let viewModel = ConversationView.ViewModel(database: mockDatabase)
        
        var roundsStarted = 0
        var roundsEnded = 0
        viewModel.$voices.sink {value in
            roundsStarted += 1
            defer {roundsEnded += 1}
            guard case .success(let voices) = value else {
                return XCTFail("Expected a successful Result, got: \(value)")
            }
            
            if(voices == firstExpectedResult) {
                XCTAssert(voices == firstExpectedResult)
            } else if (voices == secondExpectedResult) {
                XCTAssert(voices == secondExpectedResult)
                viewModel.recordButtonClicked()
                usleep(self.halfASecond)
                viewModel.recordButtonClicked()
            } else {
                XCTAssert(roundsStarted == 3)
                XCTAssert(roundsEnded == 1)
                let player = MyPlayer(data: voices.last!.recording.audioData)
                player.play()
                expectation.fulfill()
            }
        }.store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testRecordingLengthInPlayer() {
        let expectation = XCTestExpectation(description: "Player knows recording length.")
        let firstExpectedResult: [Voice] = [Voice]()
        let secondExpectedResult: [Voice] = [Voice.fixture()]
        
        let mockDatabase = MockDatabase(returning: .success(secondExpectedResult))
        let viewModel = ConversationView.ViewModel(database: mockDatabase)
        
        var roundsStarted = 0
        var roundsEnded = 0
        viewModel.$voices.sink {value in
            roundsStarted += 1
            defer {roundsEnded += 1}
            guard case .success(let voices) = value else {
                return XCTFail("Expected a successful Result, got: \(value)")
            }
            
            if(voices == firstExpectedResult) {
            } else if (voices == secondExpectedResult) {
                viewModel.recordButtonClicked()
                usleep(self.halfASecond)
                viewModel.recordButtonClicked()
            } else {
                XCTAssert(roundsStarted == 3)
                XCTAssert(roundsEnded == 1)
                
                let recording = voices.last!.recording
                let player = MyPlayer(data: recording.audioData)
                // Player duration correctness is about 0.1 seconds.
                let playerDuration = floor(10 * player.duration)
                let recordingDuration = floor(10 * recording.length)
                
                XCTAssert(playerDuration == recordingDuration)
                expectation.fulfill()
            }
        }.store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5)
    }
    
}

