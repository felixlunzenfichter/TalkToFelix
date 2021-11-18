//
// Created by Felix Lunzenfichter on 24.10.21.
//

import Foundation
import Combine

extension ConversationView {
    
    class ViewModel: ObservableObject {
        
        var cancellables = Set<AnyCancellable>()

        @Published private(set) var voices : Result<[Voice],Error> = .success([])
        @Published private(set) var isRecording: Bool = false
        
        init(database: Database) {
            database
                .getVoices()
                .sink(
                    receiveCompletion: { [weak self] completion in
                        guard case .failure(let error) = completion else {
                            return
                        }
                        self?.voices = .failure(error)
                    },
                    receiveValue: { [weak self] value in
                        self?.voices = .success(value)
                    }
                ).store(in: &cancellables)
        }
        
        func recordButtonClicked() {
            isRecording = !isRecording
        }
        
        static func fixture() -> ViewModel {
            return ViewModel(database: MockDatabase.fixture())
        }
    }
}
