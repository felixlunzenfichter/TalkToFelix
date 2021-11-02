//
// Created by Felix Lunzenfichter on 24.10.21.
//

import Foundation
import SwiftUI

protocol Database {
    
    func sendVoice(voice: Voice)

    func getVoices(user: User) -> Result<[Voice],Error>
}

enum DatabaseError: Error {
    case FailedToGetVoices
}


