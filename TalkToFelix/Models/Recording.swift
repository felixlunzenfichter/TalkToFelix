//
//  RecordingData.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 08.06.22.
//

import Foundation

struct Recording {
    let audioData: Data
    let url: URL
    let length: Double 
}

extension Recording {
    static func fixture() -> Recording {
        Recording(audioData: .fixture(), url: .fixture(), length: 69)
    }
}
