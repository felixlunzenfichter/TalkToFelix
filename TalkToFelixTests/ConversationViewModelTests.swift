//
//  ConversationViewModelTests.swift
//  TalkToFelixTests
//
//  Created by Felix Lunzenfichter on 07.11.21.
//

import XCTest
@testable import TalkToFelix
import Combine

@available(iOS 15.0.0, *)
class ConversationViewModelTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    
    func testWhenViewModelIsIniaitlizedPublishesEmptyVoices() {
        let viewModel = ConversationView.ViewModel.fixture()
        
        XCTAssertEqual(try viewModel.voices.get(), [Voice]())
    }
    
    func testVoicesAreBeingFetchedSuccessfully() {
        
        // Arrange the ViewModel and its data source
        let firstExpectedResult : [Voice] = [Voice]()
        let secondExpectedResult: [Voice] = [Voice.fixture()]
        
        let mockDatabase = MockDatabase(returning: .success(secondExpectedResult))
        let viewModel = ConversationView.ViewModel(database: mockDatabase)
        
        let expectation = XCTestExpectation(description: "Publishes expected voices successfully")
        var expectedResult = firstExpectedResult
        
        // Act on the ViewModel to trigger the update
        viewModel
            .$voices
            .sink { value in
                guard case .success(let voices) = value else {
                    return XCTFail("Expected a successful Result, got: \(value)")
                }
                
                XCTAssertEqual(expectedResult, voices)
                if (voices == firstExpectedResult){
                    expectedResult = secondExpectedResult
                } else {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // Assert the expected behavior
        wait(for: [expectation], timeout: 1)
    }
    
    func testWhenVoicesFetchingFailsPublishesError() {
        
        let expectedError = TestError()
        let mockDatabase = MockDatabase(returning: .failure(expectedError))
        let viewModel = ConversationView.ViewModel(database: mockDatabase)
        
        let expectation = XCTestExpectation(description: "Publishes an error")
        
        viewModel.$voices
            .dropFirst()
            .sink { value in
                guard case .failure(let error) = value else {
                    return XCTFail("Expected a failing result but got \(value)")
                }
                
                XCTAssertEqual(expectedError, error as? TestError)
                expectation.fulfill()
                
            }
            .store(in: &cancellables)
        
        // Assert the expected behavior
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
        
        await Task.sleep(1 * NSEC_PER_SEC)
        
        viewModel.recordButtonClicked()
        viewModel.recordButtonClicked()
        
        viewModel.$voices
            .sink { value in
                guard case .success(let voices) = value else {
                    return XCTFail("Expected 2 successfully delivered voices but got \(value)")
                }
                
                XCTAssertEqual(voices.count, 2)
                expectation.fulfill()
                
            }.store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.5)
    }
}

