//
// Created by Felix Lunzenfichter on 24.10.21.
//

import Foundation

class MockDatabase: Database {

    var voices: [Voice] = []

    func sendVoice(voice: Voice) {
        voices.append(voice)
    }

    func getVoices(user: User) -> [Voice] {
        return voices
    }

}
