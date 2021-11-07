//
// Created by Felix Lunzenfichter on 24.10.21.
//

import Foundation

extension ConversationView {

    class ViewModel: ObservableObject {

        let recordButtonText = "recordButtonText"
        
        let conversationPartner = "Carl"

        @Published private(set) var voices : [Voice] = []

        func recordButtonClicked() {}

    }
}
