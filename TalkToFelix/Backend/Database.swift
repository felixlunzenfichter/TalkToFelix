//
// Created by Felix Lunzenfichter on 24.10.21.
//

import Foundation

protocol Database {
    
    func sendVoice(voice: Voice)

    func getVoices(user: User) -> [Voice]
}
