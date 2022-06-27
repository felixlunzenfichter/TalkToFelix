//
// Created by Felix Lunzenfichter on 24.10.21.
//

import Foundation
import Combine

extension ConversationView {
    
    class ViewModel: ObservableObject {
        
        
        @Published private(set) var voices: Result<[Voice], Error> = .success([])
        
        @Published private var recorder: Recorder = MyRecorder()
        @Published private (set) var recordingLength: Double = 0.0
        @Published private(set) var isRecording: Bool = false
        
        private var cancellables = Set<AnyCancellable>()
        private var timer: Timer?
        
        init(database: Database) {
            database.getVoices().sink(receiveCompletion: {[weak self] completion in
                guard case .failure(let error) = completion else {
                    return
                }
                self?.voices = .failure(error)
            }, receiveValue: {[weak self] value in
                self?.voices = .success(value)
            }).store(in: &cancellables)
        }
        
        func recordButtonClicked() {
            defer {isRecording = !isRecording}
            if (isRecording) {
                stopRecording()
            } else {
                startRecording()
            }
        }
        
        private func startRecording() {
            recorder.start()
            startRecordingAnimation()
        }
        
        fileprivate func startRecordingAnimation() {
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {_ in
                self.recordingLength = round(self.recorder.getRecording().length * 10) / 10
            }
            RunLoop.current.add(timer!, forMode: .common)
        }
        
        private func stopRecording() {
            recorder.pause()
            addVoice()
            recorder.stop()
            stopRecordingAnimation()
        }
        
        fileprivate func addVoice() {
            var value = try! voices.get()
            value.append(Voice(recording: recorder.getRecording()))
            voices = .success(value)
        }
        
        fileprivate func stopRecordingAnimation() {
            timer?.invalidate()
            recordingLength = 0.0
        }
        
        static func fixture() -> ViewModel {
            return ViewModel(database: MockDatabase.fixture())
        }
    }
}
