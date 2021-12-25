//
//  RecordingProgressView.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 04.12.21.
//

import SwiftUI

struct RecordingProgressView: View {
    
    @ObservedObject var viewModel: ConversationView.ViewModel
    
    @State var length: Double = 0.0
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Text("\(length, specifier: "%.1f")").onReceive(timer, perform: { _ in
            length = viewModel.recordingLength
        })
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
