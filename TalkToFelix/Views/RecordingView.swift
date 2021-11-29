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
        HStack {
            Spacer()
            RecordingButton(action: viewModel.recordButtonClicked, size: 60).padding()
                .frame(width: 80, height: 80, alignment: .center)
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