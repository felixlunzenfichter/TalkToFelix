//
// Created by Felix Lunzenfichter on 24.10.21.
//

import Foundation
import Combine

class MockDatabase: Database {
    
    var voices: [Voice] = []

    func getVoices() -> AnyPublisher<[Voice],Error> {
        return Future { $0(.success(self.voices)) }
                   // Use a delay to simulate async fetch
            .delay(for: 0.5, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
        
}

extension MockDatabase {
    
    private func setVoices(voices: [Voice]) {
        self.voices = voices
    }
    
    static func fixture() -> MockDatabase {
        let fixtureMockDatabase = MockDatabase()
        fixtureMockDatabase.setVoices(voices: [Voice.fixture(), Voice.fixture(), Voice.fixture()])
        return fixtureMockDatabase
    }
    
}
