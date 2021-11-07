//
//  ContentView.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 14.10.21.
//

import SwiftUI

struct ConversationView: View {

    var viewModel = ViewModel()

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.voices) {voice in
                        Text(voice.speaker.name)
                    }
                }
                Button(viewModel.recordButtonText, action: viewModel.recordButtonClicked)
            }
        .navigationTitle("\(viewModel.conversationPartner)")
        }
    }
}

struct ConversationView_Previews: PreviewProvider {

    static var previews: some View {
        ConversationView(viewModel:
                            ConversationView.ViewModel()
                         )
    }
}


