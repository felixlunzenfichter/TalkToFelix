//
//  VoiceView.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 29.12.21.
//

import SwiftUI

struct VoiceView: View {
    
    @ObservedObject var voice: Voice
    let player: Player
    
    var body: some View {
        VStack (alignment: .leading){
            Text("\(voice.recording.length , specifier: "%.1f")")
            Text(voice.transcription.transcript)
        }.onTapGesture {
            player.play()
        }.foregroundColor(voice.transcription.isFinal ? .red : .purple)
    }
    
    init(voice: Voice) {
        self.voice = voice
        self.player = MyPlayer(data: voice.recording.audioData)
    }
    
}

struct VoiceView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceView(voice: .fixture())
    }
}
