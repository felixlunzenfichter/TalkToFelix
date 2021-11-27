//
//  File.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 22.11.21.
//

import Foundation
import Combine

class ResultToCurrentValueSubjectConverter {
    
    static func convert(result: Result<[Voice],Error>) -> CurrentValueSubject<[Voice], Error> {
        
        let currentValueSubject: CurrentValueSubject<[Voice],Error> = CurrentValueSubject([])
        
        switch result {
        case .failure(let error):
            currentValueSubject.send(completion: .failure(error))
        case .success(let voices):
            currentValueSubject.send(voices)
        }
        
        return currentValueSubject
    }
}
