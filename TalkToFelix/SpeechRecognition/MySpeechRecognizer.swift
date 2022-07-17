import AVFoundation
import Foundation
import Speech
import SwiftUI

@available(iOS 16.0, *)
class MySpeechRecognizer: NSObject, ObservableObject, SpeechRecognizer {
    
    var myRecognizer: SFSpeechRecognizer!
    var serialQueue: DispatchQueue!
    var group: DispatchGroup!
    
    override init() {
        serialQueue = DispatchQueue(label: "serialQueue")
        group = DispatchGroup()
        myRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "es_MX"))
    }
    
    func transcribe(voice: Voice) {
        
        serialQueue.async { [self] in
            
            let request = SFSpeechURLRecognitionRequest(url: voice.recording.url)
            request.addsPunctuation = true
            group.wait()
            group.enter()
            
            if (!myRecognizer.isAvailable) {
                handle(error: SpeechRecognizerError.notAvailable)
                return
            }
            
            myRecognizer!.recognitionTask(with: request) { (result, error) in
                guard let result = result else {
                    if (error.unsafelyUnwrapped.localizedDescription.contains("No speech")) {
                        voice.transcription = Transcription(isFinal: true)
                    }
                    handle(error: error!)
                    self.group.leave()
                    return
                }
                
                if result.isFinal {
                    voice.transcription = Transcription(isFinal: true, result: result)
                    self.group.leave()
                } else {
                    voice.transcription = Transcription(result: result)
                }
            }
        }
    }
}

