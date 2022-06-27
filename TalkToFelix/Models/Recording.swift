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
