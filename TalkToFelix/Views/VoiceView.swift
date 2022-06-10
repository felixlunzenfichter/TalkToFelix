//
//  VoiceView.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 29.12.21.
//

import SwiftUI

struct VoiceView: View {

    let voice: Voice

    var body: some View {
        Text("\(voice.recording.length , specifier: "%.1f")")
        Text(voice.transcript!)
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
