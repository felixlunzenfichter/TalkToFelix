//
//  VoiceViewModel.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 20.07.22.
//

import Foundation
import Combine

extension VoiceView {
    class ViewModel: ObservableObject {
        @Published var transcript: String
        @Published var transcriptIsFinal: Bool
        var duration: Double
        var voice: Voice
        
        var cancellables = Set<AnyCancellable>()
        
        init(voice: Voice) {
            self.voice = voice
            duration = voice.recording.length
            transcript = voice.transcription.transcript
            transcriptIsFinal = voice.transcription.isFinal
            
            voice.$transcription.sink { transcription in
                self.transcript = transcription.transcript
                self.transcriptIsFinal = transcription.isFinal
            }.store(in: &cancellables)
        }
    }
}
