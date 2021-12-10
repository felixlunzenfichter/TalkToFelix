//
//  Recorder.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 04.12.21.
//

import Foundation
import AVFoundation

class MyRecorder: Recorder {
    
    let audioFilename = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("recording.m4a")
    
    let settings = [
        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
        AVSampleRateKey: 12000,
        AVNumberOfChannelsKey: 1,
        AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue
    ]
    
    lazy var length: Double = {
        return audioRecorder?.currentTime ?? 0
    }()
    
    lazy var audioData: Data = {
        try! Data(contentsOf: audioFilename)
    }()
    
    private var recordingSession: AVAudioSession = AVAudioSession.sharedInstance()
    private var audioRecorder: AVAudioRecorder!
    
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
    
    func stop() {
        audioRecorder.stop()
        audioRecorder = nil
    }
    
    init() {
        do {
            try recordingSession.setCategory(.record, mode: .default)
        } catch {
            print("failed to initialize Recorder with error: \(error)")
        }
    }
    
}


