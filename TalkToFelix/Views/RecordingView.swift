//
//  RecordingView.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 26.11.21.
//

import SwiftUI

struct RecordingView: View {
    
    @ObservedObject var viewModel: ConversationView.ViewModel
    
    var body: some View {
        VStack {
            switch viewModel.isRecording {
            case true:
                Text("Recording")
            case false:
                Text("Not recording")
            }
            Button("recordButtonText", action: viewModel.recordButtonClicked)
        }
    }
    
    init(viewModel: ConversationView.ViewModel) {
        self.viewModel = viewModel
    }
    
}

struct RecordingView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingView(viewModel: ConversationView.ViewModel.fixture())
    }
}
