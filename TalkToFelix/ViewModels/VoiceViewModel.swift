//
//  VoiceViewModel.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 20.07.22.
//

import Foundation
import Combine
import SwiftUI

extension VoiceView {
    class ViewModel: ObservableObject {
        @Published var transcript: String
        @Published var transcriptIsFinal: Bool
        @Published var voicingGraphData: [VoicingGraphPoint]
        
        var duration: Double
        var voice: Voice
        
        var cancellables = Set<AnyCancellable>()
        
        init(voice: Voice) {
            self.voice = voice
            duration = voice.recording.length
            transcript = voice.transcription.transcript
            transcriptIsFinal = voice.transcription.isFinal
            voicingGraphData = []
            
            voice.$transcription.sink { transcription in
                self.transcript = transcription.transcript
                self.transcriptIsFinal = transcription.isFinal
                
                if (!transcription.isFinal) {return}
                
                let values = transcription.voicing.values
                let frameDuration = transcription.voicing.frameDuration
                let startTime = transcription.startTime
                
                voice.$listeningEvents.sink { listeningEvents in
                    var index = 0.0
                    let time = index * frameDuration + startTime
                    if (listeningEvents.isEmpty) {
                        self.voicingGraphData = values.map {
                            index += 1
                            return VoicingGraphPoint(time: time, value: $0, listeningState: ListeningState.hasNotBeenListenedTo)}
                    } else {
                        let mostRecentListeningEvent = listeningEvents.last!
                        self.voicingGraphData = values.map {
                            index += 1
                            let listeningState: ListeningState
                            if (time < mostRecentListeningEvent.endTime) {
                                listeningState = ListeningState.hasBeenListenedTo
                            } else if (time == mostRecentListeningEvent.endTime) {
                                listeningState = ListeningState.isBeingListenedTo
                            } else {
                                listeningState = ListeningState.hasNotBeenListenedTo
                            }
                            return VoicingGraphPoint(time: time, value: $0, listeningState: listeningState)
                        }
                    }
                }.store(in: &self.cancellables)
                
                
            }.store(in: &cancellables)
            
            
        }
    }
}

struct VoicingGraphPoint {
    let time: Double
    let value: Double
    let listeningState: ListeningState
    var color: Color { .red }
}

enum ListeningState {
    case hasNotBeenListenedTo
    case isBeingListenedTo
    case hasBeenListenedTo
}
