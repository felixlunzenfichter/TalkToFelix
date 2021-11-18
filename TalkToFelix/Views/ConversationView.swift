//
//  ContentView.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 14.10.21.
//

import SwiftUI

struct ConversationView: View {
    
    @ObservedObject var viewModel: ViewModel = .fixture()
    
    var body: some View {
        NavigationView {
            switch viewModel.voices {
            case .success(let voices):
                VStack {
                    List {
                        ForEach(voices) {voice in
                            Text(voice.speaker.name)
                        }
                    }
                switch viewModel.isRecording {
                case true:
                    Text("Recording")
                case false:
                    Text("Not recording")
                }
                    
                    
                    Button("recordButtonText", action: viewModel.recordButtonClicked)
                }.navigationTitle("Carli <3")
            case .failure(let error):
                Text("An error occurred:")
                Text(error.localizedDescription).italic()
            }
        }
    }
}

struct ConversationView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationView()
    }
}




