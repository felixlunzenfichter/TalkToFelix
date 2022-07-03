//
//  Recorder.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 04.12.21.
//

import Foundation
import AVFoundation

class MyRecorder: Recorder {

    let audioFilename: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("recording.m4a")

    var length: Double {
        return audioRecorder?.currentTime ?? 0
    }

    private var recordingSession: AVAudioSession {AVAudioSession.sharedInstance()}
    private var audioRecorder: AVAudioRecorder!

    private var audioData: Data {
        guard let data = try Data(contentsOf: self.audioFilename) ~> RecorderError.getData else {
            return Data()
        }
        return data
    }

    private let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue]

    func start() {
        
        func startThrows() throws {
            try recordingSession.setCategory(.record)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission {allowed in}
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.record()
        }
        
        try startThrows() ~> RecorderError.start
        
    }
    
    func pause() {
        audioRecorder.pause()
    }

    func stop() {
        audioRecorder?.stop()
        audioRecorder = nil
    }
    
    func getRecording() -> Recording {
        return Recording(audioData: audioData, url: audioFilename, length:length)
    }
    
    func getFinalRecording() -> Recording {
        audioRecorder.pause()
        let duration = length
        stop()
        return Recording(audioData: audioData, url: audioFilename, length:duration)
    }

    init() {
        try recordingSession.setCategory(.record, mode: .default) ~> RecorderError.initialize
    }

}



