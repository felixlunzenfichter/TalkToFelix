//
//  VoiceView.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 29.12.21.
//

import SwiftUI

struct VoiceView: View {
    
    @StateObject var viewModel: ViewModel
    @EnvironmentObject var conversationViewModel: ConversationView.ViewModel

    var body: some View {
        VStack (alignment: .leading){
            Text("\(viewModel.duration, specifier: "%.1f")")
            Text(viewModel.transcript)
        }.onTapGesture {
            conversationViewModel.listenTo(voice: viewModel.voice)
        }.foregroundColor(viewModel.transcriptIsFinal ? .red : .purple)
    }
    
    init(voice: Voice) {
        _viewModel = StateObject(wrappedValue: ViewModel(voice: voice))
    }
    
}

struct VoiceView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceView(voice: .fixture())
    }
}
