//
// Created by Felix Lunzenfichter on 24.10.21.
//

import Foundation
import Combine

extension ConversationView {
    
    class ViewModel: ObservableObject {
        
        @Published private(set) var voices: Result<[Voice], Error> = .success([])
       
        internal var recorder: Recorder = MyRecorder()
        private var player: Player!
        
        @Published private (set) var recordingLength: Double = 0.0
        @Published private(set) var isRecording: Bool = false
        
        private var cancellables = Set<AnyCancellable>()
        private var timer: Timer?
        private var timer2: Timer?
        
        init(database: Database) {
            database.getVoices().sink(receiveCompletion: {[weak self] completion in
                guard case .failure(let error) = completion else {
                    return
                }
                self?.voices = .failure(error)
            }, receiveValue: {[weak self] value in
                self?.voices = .success(value)
                value.map {MySpeechRecognizer.transcribe(voice: $0)}
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
            addVoiceToConversation(newVoice: Voice(recording: recorder.getFinalRecording()))
            stopRecordingAnimation()
        }
        
        fileprivate func addVoiceToConversation(newVoice: Voice) {
            var voices = try! voices.get()
            MySpeechRecognizer.transcribe(voice: newVoice)
            voices.append(newVoice)
            self.voices = .success(voices)
        }
        
        fileprivate func stopRecordingAnimation() {
            timer?.invalidate()
            recordingLength = 0.0
        }
        
        func listenTo(voice: Voice) {
            voice.listeningEvents.append(ListeningEvent(isFinal: false, startTime: 0, endTime: 0))
            player = MyPlayer(data: voice.recording.audioData)
            let didFinishPlayingCallback = {
                var listeningEvent = voice.listeningEvents.last!
                listeningEvent.isFinal = true
                listeningEvent.endTime = voice.recording.length
                voice.listeningEvents[voice.listeningEvents.count - 1] = listeningEvent
            }
            startListeningAnimation(voice: voice)
            player.play(didFinishPlayingCallback: didFinishPlayingCallback)
        }
        
        fileprivate func startListeningAnimation(voice: Voice) {
            timer2 = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {_ in
                var listeningEvents = voice.listeningEvents
                var currentListeningEvent = listeningEvents.last!
                if (currentListeningEvent.isFinal) {
                    self.timer2?.invalidate()
                    return
                }
                currentListeningEvent.endTime = self.player.currentTime
                listeningEvents[listeningEvents.count - 1] = currentListeningEvent
                voice.listeningEvents = listeningEvents
            }
            RunLoop.current.add(timer2!, forMode: .common)
        }
        
        static func fixture() -> ViewModel {
            return ViewModel(database: MockDatabase.fixture())
        }
    }
}
