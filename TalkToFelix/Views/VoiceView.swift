//
//  VoiceView.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 29.12.21.
//

import SwiftUI

struct VoiceView: View {
    
    @ObservedObject var voice: Voice
    @EnvironmentObject var viewModel: ConversationView.ViewModel

    var body: some View {
        VStack (alignment: .leading){
            Text("\(voice.recording.length , specifier: "%.1f")")
            Text(voice.transcription.transcript)
        }.onTapGesture {
            viewModel.listenTo(voice: voice)
        }.foregroundColor(voice.transcription.isFinal ? .red : .purple)
    }
    
    init(voice: Voice) {
        self.voice = voice
    }
    
}

struct VoiceView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceView(voice: .fixture())
    }
}
