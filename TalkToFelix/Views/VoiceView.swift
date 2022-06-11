//
//  VoiceView.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 29.12.21.
//

import SwiftUI

@available(iOS 15.0, *)
struct VoiceView: View {

    let voice: Voice

    var body: some View {
        
        Text("\(voice.recording.length , specifier: "%.1f")").listRowSeparatorTint(.secondary)
        Text(voice.transcript!).listRowSeparatorTint(.primary)
            
        
    }

    init(voice: Voice) {
        self.voice = voice
    }

}

@available(iOS 15.0, *)
struct VoiceView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceView(voice: .fixture())
    }
}
