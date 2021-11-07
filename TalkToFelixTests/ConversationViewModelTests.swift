//
//  ConversationViewModelTests.swift
//  TalkToFelixTests
//
//  Created by Felix Lunzenfichter on 07.11.21.
//

import XCTest
@testable import TalkToFelix

class ConversationViewModelTests: XCTestCase {

    func testWhenViewModelIsIniaitlizedPublishesEmptyVoices() {
        let viewModel = ConversationView.ViewModel()
        
        XCTAssertTrue(viewModel.voices.isEmpty)
    }
    
    func testVoicesFetchingIsSuccessful() {
        
    }
    
    func testWhenVoicesFetchingFailsPublishesError() {
        
    }

}
