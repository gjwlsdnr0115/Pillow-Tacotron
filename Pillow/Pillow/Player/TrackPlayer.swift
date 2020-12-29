//
//  TrackPlayer.swift
//  Pillow
//
//  Created by Jinwook Huh on 2020/12/20.
//

import AVFoundation

class TrackPlayer {
    
    static let shared = TrackPlayer()
    private let player = AVPlayer()
    
    var currentTime: Double {
        return player.currentItem?.currentTime().seconds ?? 0
    }
    
    var remainingTime: Double {
        let duration = player.currentItem?.duration.seconds ?? 0
        let currentTime = player.currentItem?.currentTime().seconds ?? 0
        let remainingTime = duration - currentTime
        return remainingTime
    }
    
    var totalDurationTime: Double {
        return player.currentItem?.duration.seconds ?? 0
    }
    
    var isPlaying: Bool {
        return player.isPlaying
    }
    
    var currentItem: AVPlayerItem? {
        return player.currentItem
    }
    
    init() {}
    
    func pause()  {
        player.pause()
    }
    
    func play()  {
        player.play()
    }
    
    func seek(to time:CMTime)  {
        player.seek(to: time)
    }
    
    func replaceCurrentItem(with item:AVPlayerItem?) {
        player.replaceCurrentItem(with: item)
    }
    
    func addPeriodicTimeObserver(forInterval: CMTime, queue: DispatchQueue?, using: @escaping (CMTime) -> Void) {
        player.addPeriodicTimeObserver(forInterval: forInterval, queue: queue, using: using)
    }
}
