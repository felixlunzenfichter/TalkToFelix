//
//  RecordingProgressView.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 04.12.21.
//

import SwiftUI

struct RecordingProgressView: View {

    @EnvironmentObject var viewModel: ConversationView.ViewModel

    var body: some View {
        Text("\(viewModel.recordingLength, specifier: "%.1f")")
    }

}

struct RecordingProgressView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingProgressView().environmentObject(ConversationView.ViewModel.fixture())
    }
}
