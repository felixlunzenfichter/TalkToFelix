//
//  ContentView.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 14.10.21.
//

import SwiftUI

struct ConversationView: View {
    
    @StateObject var viewModel: ViewModel = .fixture()
    
    var body: some View {
        NavigationView {
            switch viewModel.voices {
            case .success(let voices):
                VStack {
                    List {
                        ForEach(voices) {voice in
                            VoiceView(voice: voice)
                        }
                    }
                    RecordingView()
                }.navigationTitle("Carli <3")
            case .failure(let error):
                Text("An error occurred:")
                Text(error.localizedDescription).italic()
            }
        }.environmentObject(viewModel)
    }
}

struct ConversationView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationView()
    }
}




