//
// Created by Felix Lunzenfichter on 24.10.21.
//

import Foundation
import Combine

extension ConversationView {

    class ViewModel: ObservableObject {
        
        var cancellables = Set<AnyCancellable>()

        @Published private(set) var voices : Result<[Voice],Error> = .success([])
        
        init(database: Database) {
            database
                .getVoices()
                .sink(
                    receiveCompletion: { _ in },
                    receiveValue: { [weak self] value in
                        self?.voices = .success(value)
                    }
                ).store(in: &cancellables)
        }

        func recordButtonClicked() {}

    }
}
