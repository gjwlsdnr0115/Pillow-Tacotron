//
//  Extension+AVPlayer.swift
//  Pillow
//
//  Created by Jinwook Huh on 2020/12/20.
//

import AVFoundation
import UIKit

extension AVPlayer {
    var isPlaying: Bool {
        guard self.currentItem != nil else { return false }
        return self.rate != 0
    }
}
