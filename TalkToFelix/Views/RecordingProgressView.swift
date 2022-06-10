//
//  RecordingProgressView.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 04.12.21.
//

import SwiftUI

@available(iOS 15.0, *)
struct RecordingProgressView: View {

    @EnvironmentObject var viewModel: ConversationView.ViewModel

    var body: some View {
        VStack {
            Text("\(viewModel.recordingLength, specifier: "%.1f")").frame(maxWidth: .infinity, alignment:.leading)
            Text(viewModel.currentTranscript).frame(maxWidth: .infinity, alignment: .leading)
        }
    }

}

@available(iOS 15.0, *)
struct RecordingProgressView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingProgressView().environmentObject(ConversationView.ViewModel.fixture())
    }
}
