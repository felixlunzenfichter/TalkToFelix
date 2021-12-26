//
//  RecordingProgressView.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 04.12.21.
//

import SwiftUI

struct RecordingProgressView: View {

    @ObservedObject var viewModel: ConversationView.ViewModel

    var body: some View {
        Text("\(viewModel.recordingLength, specifier: "%.1f")")
    }

    init(viewModel: ConversationView.ViewModel) {
        self.viewModel = viewModel
    }
}

struct RecordingProgressView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingProgressView(viewModel: ConversationView.ViewModel.fixture())
    }
}
