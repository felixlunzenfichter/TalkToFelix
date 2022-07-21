//
// Created by Felix Lunzenfichter on 24.10.21.
//

import Combine

protocol Database {
    func getVoices() -> AnyPublisher<[Voice],Error>
}



