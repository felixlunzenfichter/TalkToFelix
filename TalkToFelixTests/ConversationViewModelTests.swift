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
        let viewModel = ConversationView.ViewModel(database: MockDatabase())
        
        XCTAssertTrue(viewModel.voices.isEmpty)
    }
    
    func testVoicesFetchingIsSuccessful() {
        
        // Arrange the ViewModel and its data source
        let mockDatabase = MockDatabase.fixture()
        let viewModel = ConversationView.ViewModel(database: mockDatabase)
        
        let expectation = XCTestExpectation(description: "Publishes expected voices")
        var expectedResult = [Voice]()
        
        // Act on the ViewModel to trigger the update
        viewModel
            .$voices
            .sink { value in
                XCTAssertEqual(expectedResult, value)
                if (expectedResult == [Voice]()) {
                    expectedResult = mockDatabase.voices
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
