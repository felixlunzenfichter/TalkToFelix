//
// Created by Felix Lunzenfichter on 24.10.21.
//

import Foundation
import SwiftUI
import Combine

protocol Database {
    
    func getVoices() -> AnyPublisher<[Voice],Error>
    
    
    
}

enum DatabaseError: Error {
    case FailedToGetVoices
}


