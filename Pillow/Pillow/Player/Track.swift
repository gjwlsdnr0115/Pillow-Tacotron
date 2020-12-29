//
//  Track.swift
//  Pillow
//
//  Created by Jinwook Huh on 2020/12/20.
//

import UIKit
import AVFoundation

struct Track {
    let audio: AVPlayerItem
    let script: String
    
    init(file: AVPlayerItem, text: String) {
        self.audio = file
        self.script = text
    }
}

