//
//  RecordingData.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 08.06.22.
//

import Foundation

struct Recording {
    var audioData: Data = Data()
    var url: URL = URL(filePath: "")
    var length: Double = 0.0
}

extension Recording {
    static private let url = URL(fileURLWithPath: Bundle.main.path(forResource: "good.aac", ofType:nil)!)

    static func fixture() -> Recording {
        Recording(audioData: .fixture(), url: url, length: 69)
        
    }
}
