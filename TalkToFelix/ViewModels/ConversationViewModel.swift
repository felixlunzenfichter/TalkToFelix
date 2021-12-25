//
// Created by Felix Lunzenfichter on 24.10.21.
//

import Foundation
import Combine
import SwiftUI

extension ConversationView {
    
    class ViewModel: ObservableObject {
        
        var cancellables = Set<AnyCancellable>()
        
        @Published private(set) var voices : Result<[Voice],Error> = .success([])
        @Published private(set) var isRecording: Bool = false
        
        @Published var recorder: Recorder = MyRecorder()

        public var recordingLength: Double {
            (round(10 * recorder.length) / 10)
        }

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
            if(isRecording) {
                addVoice()
                let _ = recorder.stop()
            } else {
                recorder.start()
            }
            isRecording = !isRecording
        }
        
        fileprivate func addVoice() {
            var value = try! voices.get()
            value.append(Voice.fixture())
            voices = .success(value)
        }
        
        static func fixture() -> ViewModel {
            return ViewModel(database: MockDatabase.fixture())
        }
    }
}
