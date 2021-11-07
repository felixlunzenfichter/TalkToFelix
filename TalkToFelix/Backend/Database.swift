//
// Created by Felix Lunzenfichter on 24.10.21.
//

import Foundation
import SwiftUI

protocol Database {
    
    func getVoices() -> Result<[Voice],Error>
    
}

enum DatabaseError: Error {
    case FailedToGetVoices
}


