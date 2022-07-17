//
//  VoiceView.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 29.12.21.
//

import SwiftUI
import Charts

struct VoiceView: View {
    
    @EnvironmentObject var conversationViewModel: ConversationView.ViewModel
    @ObservedObject var viewModel: VoiceView.ViewModel

    var body: some View {
        VStack (alignment: .leading) {
            Text("\(viewModel.length , specifier: "%.1f")")
                
            Chart (viewModel.graphData) {
                BarMark (
                    x: .value("segment", $0.index),
                    y: .value("voicing", $0.value)
                ).foregroundStyle($0.color)
            }
                
            Text(viewModel.transcript)
        }.onTapGesture {
            conversationViewModel.listenTo(voice: viewModel.voice)
        }.foregroundColor(viewModel.textColor)
    }
    
    init(voice: Voice) {
        self.viewModel = VoiceView.ViewModel(voice: voice)
    }
    
}

struct VoiceView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceView(voice: .fixture())
    }
}
