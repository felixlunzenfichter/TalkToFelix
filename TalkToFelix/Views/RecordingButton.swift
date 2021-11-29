//
//  RecordingButton.swift
//  TalkToFelix
//
//  Created by Felix Lunzenfichter on 28.11.21.
//

import SwiftUI

struct RecordingButton: View {
    
    @State var cornerRadius: CGFloat
    @State var size: CGFloat
    @State var isRecording: Bool = false
    
    var action: () -> ()
    
    var body: some View {
        
        Rectangle()
            .fill(.red)
            .frame(width: size, height: size, alignment: .center)
            .cornerRadius(cornerRadius)
            .animation(.easeInOut(duration: 0.25), value: size)
            .animation(.easeInOut(duration: 0.25), value: cornerRadius)
            .onTapGesture {
                action()
                isRecording = !isRecording
                size = isRecording ? size/2 : size*2
                cornerRadius = isRecording ? size/4 : size/2
            }
    }
    
    init(action: @escaping () -> (), size: CGFloat = 40) {
        self.action = action
        self.size = size
        cornerRadius = size/2
    }
    
}

struct RecordingButton_Previews: PreviewProvider {
    static var previews: some View {
        RecordingButton(action: {})
    }
}
