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

    private var recordingSession: AVAudioSession = AVAudioSession.sharedInstance()
    private var audioRecorder: AVAudioRecorder!

    private var audioData: Data {
        var data: Data
        do {
            data = try Data(contentsOf: audioFilename)
        } catch {
            return Data()
        }
        return data
    }

    private let settings = [
        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
        AVSampleRateKey: 12000,
        AVNumberOfChannelsKey: 1,
        AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue
    ]
    
    func start() {
        do {
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission { allowed in }
        } catch {
            print("failed to start recording with error: \(error)")
        }
        
        audioRecorder = try! AVAudioRecorder(url: audioFilename, settings: settings)
        audioRecorder.record()
    }
    
    func stop() -> Data {
        audioRecorder?.stop()
        audioRecorder = nil
        return audioData
    }
    
    init() {
        do {
            try recordingSession.setCategory(.record, mode: .default)
        } catch {
            print("failed to initialize Recorder with error: \(error)")
        }
    }
    
}


