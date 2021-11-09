//
// Created by Felix Lunzenfichter on 24.10.21.
//

import Foundation
import Combine

class MockDatabase: Database {
    
    var result: Result<[Voice],Error> = .success([])
    
    init(returning result: Result<[Voice],Error>) {
        self.result = result
    }

    func getVoices() -> AnyPublisher<[Voice],Error> {
        return result.publisher
                   // Use a delay to simulate async fetch
            .delay(for: 0.5, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
        
}

extension MockDatabase {
    
    static func fixture() -> MockDatabase {
        return MockDatabase(returning: .success([Voice.fixture(), Voice.fixture(), Voice.fixture()]))
    }
    
}
