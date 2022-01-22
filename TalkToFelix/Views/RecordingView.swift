//
//  RecordingView.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 26.11.21.
//

import SwiftUI

struct RecordingView: View {
    
    @EnvironmentObject var viewModel: ConversationView.ViewModel
    
    var body: some View {
        HStack {
            RecordingProgressView()
            Spacer()
            RecordingButton(
                action:viewModel.recordButtonClicked,
                size: 60
            ).frame(width: 80, height: 80, alignment: .center)
        }.padding()
    }
    
}

struct RecordingView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingView().environmentObject(ConversationView.ViewModel.fixture())
    }
}
