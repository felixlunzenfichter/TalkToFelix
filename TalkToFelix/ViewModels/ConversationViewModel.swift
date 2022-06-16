//
// Created by Felix Lunzenfichter on 24.10.21.
//

import Foundation
import Combine
import SwiftUI

@available(iOS 15.0, *)
extension ConversationView {

    @available(iOS 15.0, *)
    class ViewModel: ObservableObject {

        var cancellables = Set<AnyCancellable>()

        @Published private(set) var voices: Result<[Voice], Error> = .success([])
        @Published private(set) var isRecording: Bool = false

        @Published private var recorder: Recorder = MyRecorder()
        @Published private (set) var recordingLength: Double = 0.0
        @Published var speechRecognizer: SpeechRecognizer = MySpeechRecognizer()
        @Published var currentTranscript: String = ""
        

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
            speechRecognizer.reset()
            speechRecognizer.transcribe()
            recorder.start()
            startRecordingAnimation()
        }
        
        fileprivate func startRecordingAnimation() {
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {_ in
                self.recordingLength = round(self.recorder.getRecording().length * 10) / 10
                self.currentTranscript = self.speechRecognizer.transcript
            }
            RunLoop.current.add(timer!, forMode: .common)
        }

        private func stopRecording() {
            recorder.pause()
            speechRecognizer.stopTranscribing()
            
            addVoice()
            recorder.stop()
            resetRecordingAnimation()
        }
        
        fileprivate func resetRecordingAnimation() {
            timer?.invalidate()
            recordingLength = 0.0
            currentTranscript = ""
        }

        fileprivate func addVoice() {
            var value = try! voices.get()
            value.append(Voice(speaker: ThisUser(), listener: User(name: "Carli <3"), recording: recorder.getRecording(), transcript: speechRecognizer.transcript))
            voices = .success(value)
        }

        static func fixture() -> ViewModel {
            return ViewModel(database: MockDatabase.fixture())
        }
    }
}
