//
//  ConversationViewModelTests.swift
//  TalkToFelixTests
//
//  Created by Felix Lunzenfichter on 07.11.21.
//

import XCTest
@testable import TalkToFelix
import Combine

class ConversationViewModelTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()

    func testWhenViewModelIsIniaitlizedPublishesEmptyVoices() {
        let viewModel = ConversationView.ViewModel(database: MockDatabase.fixture())
        
        XCTAssertTrue(viewModel.voices.isEmpty)
    }
    
    func testVoicesFetchingIsSuccessful() {
        
        // Arrange the ViewModel and its data source
        let firstExpectedResult : [Voice] = [Voice]()
        let secondExpectedResult: [Voice] = [Voice.fixture()]
        
        let mockDatabase = MockDatabase(returning: .success(secondExpectedResult))
        let viewModel = ConversationView.ViewModel(database: mockDatabase)
        
        let expectation = XCTestExpectation(description: "Publishes expected voices")
        var expectedResult = firstExpectedResult

        
        // Act on the ViewModel to trigger the update
        viewModel
            .$voices
            .sink { value in
                XCTAssertEqual(expectedResult, value)
                if (expectedResult == firstExpectedResult){
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
        
    }

}
