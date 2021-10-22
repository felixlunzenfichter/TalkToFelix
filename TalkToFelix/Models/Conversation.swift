//
//  Conversation.Swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 14.10.21.
//

import Foundation

class Conversation {

    var voices: [Voice]

    let participants: [User]

    init(conversationPartner: User, voices: [Voice]) {
        self.participants = [ThisUser(), conversationPartner]
        self.voices = voices
    }

}
