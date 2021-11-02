//
// Created by Felix Lunzenfichter on 24.10.21.
//

import Foundation

class MockDatabase: Database {

    var voices: [Voice] = []

    func sendVoice(voice: Voice) {}

    func getVoices(user: User) -> Result<[Voice],Error> {
        return Result.failure(DatabaseError.FailedToGetVoices)
    }
    
}
