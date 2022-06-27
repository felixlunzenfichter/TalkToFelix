//
//  ResultToCurrentValueSubjectConverterTests.swift
//  TalkToFelixTests
//
//  Created by Felix Lunzenfichter on 22.11.21.
//

import XCTest
@testable import TalkToFelix
import Combine

class ResultToCurrentValueSubjectConverterTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    
    func testResultErrorToCurrentValueSubjectErrorConversion() {
        
        let failureError = TestError()
        let resultError: Result<[Voice],Error> = .failure(failureError)
        let expectation = XCTestExpectation(description: "expected the currentValueSubject to emit the same error we used to define the result.")
        
        let currentValueSubjectError = ResultToCurrentValueSubjectConverter.convert(result: resultError)
        
        currentValueSubjectError.sink (
            receiveCompletion: {completion in
                guard case .failure(let error) = completion else {
                    return XCTFail("Expected an error")
                }
                XCTAssertEqual(error as? TestError, failureError)
                expectation.fulfill()
            },
            receiveValue: { value in
                XCTAssertEqual([], value)
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testResultSuccessToCurrentValueSubjectOutputConversion() {
        
        let sucessVoices = [Voice.fixture(), Voice.fixture()]
        let resultSuccess:  Result<[Voice],Error> = .success(sucessVoices)
        let currentValueSubjectOutput   = ResultToCurrentValueSubjectConverter.convert(result: resultSuccess)
        
        let expectation = XCTestExpectation(description: "Expected to receive the same voices we fed into result.")
        
        currentValueSubjectOutput
            .sink(receiveCompletion: {completion in
                return XCTFail("Expected a value but received completion: \(completion)")
            }, receiveValue: { value in
                XCTAssertEqual(sucessVoices, value)
                expectation.fulfill()
            }).store(in: &cancellables)
        
        wait(for: [expectation], timeout: 0.1)
    }
    
}

