//
//  VoiceViewModel.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 17.07.22.
//

import Foundation
import SwiftUI
import Combine


extension VoiceView {
    class ViewModel: ObservableObject {
        
        let voice: Voice
        
        @Published var transcript: String = ""
        @Published var length: Double = 0.0
        @Published var textColor: Color = .red
        @Published var graphData: [GraphDataPoint] = []
        
        private var cancellables = Set<AnyCancellable>()
        
        init(voice: Voice) {
            self.voice = voice
            
            voice.$transcription.sink {
                transcription in
                self.transcript = transcription.transcript
                self.textColor = transcription.isFinal ? .red : .purple
                if (transcription.isFinal) {
                    self.initializeGraphData(voicing: transcription.voicing)
                    voice.$listeningEvents.sink {
                        listeningEvents in
                        if (listeningEvents.isEmpty) {return}
                        self.updateGraphData(listeningEvents: listeningEvents, voicing: transcription.voicing)
                    }.store(in: &self.cancellables)
                }
            }.store(in: &cancellables)
        }
        
        func initializeGraphData(voicing: Voicing){
            var index = 0
            var graphData: [GraphDataPoint] = []
            voicing.values.forEach {
                value in
                graphData.append(GraphDataPoint(index: index, value: value, color: .red))
                index += 1
            }
            self.graphData = graphData
        }
        func updateGraphData(listeningEvents: [ListeningEvent], voicing: Voicing){
            var current = listeningEvents.last!
            var ratio = (current.endTime - current.startTime)/voice.recording.length
            
            
            var index = 0
            var graphData: [GraphDataPoint] = []
            voicing.values.forEach {
                value in
                var position = Double(index) / Double(voicing.values.count)
                let color: Color = position > ratio ? .red : .purple
                graphData.append(GraphDataPoint(index: index, value: value, color: color))
                index += 1
            }
            self.graphData = graphData
        }
        
        
        class GraphDataPoint: Identifiable {
            let id = UUID()
            let index: Int
            let value: Double
            let color: Color
            
            init(index: Int, value: Double, color: Color) {
                self.index = index
                self.value = value
                self.color = color
            }
        }
    }
}
