//
//  PlayerViewController.swift
//  Pillow
//
//  Created by Jinwook Huh on 2020/12/20.
//

import UIKit
import Foundation
import AVFoundation

class PlayerViewController: UIViewController {

    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    
    @IBOutlet weak var playControlButton: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var volumeSlider: UISlider!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let trackPlayer = TrackPlayer.shared
    var timeObserver: Any?
    var isSeeking: Bool = false
    
    var script = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updatePlayButton()
        updateTime(time: CMTime.zero)
        timeObserver = trackPlayer.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 10), queue: DispatchQueue.main) { time in
            self.updateTime(time: time)
        }
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let thumb = UIImage(named: "thumb")
        timeSlider.setThumbImage(thumb, for: .normal)
        timeSlider.setThumbImage(thumb, for: .highlighted)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        trackPlayer.pause()
        trackPlayer.replaceCurrentItem(with: nil)
    }
    
    @IBAction func beginDrag(_ sender: UISlider) {
        isSeeking = true
    }
    
    @IBAction func endDrag(_ sender: UISlider) {
        isSeeking = false
    }
    
    @IBAction func seek(_ sender: UISlider) {
        guard let currentItem = trackPlayer.currentItem else { return }
        let position = Double(sender.value)
        let seconds = currentItem.duration.seconds * position
        let time = CMTime(seconds: seconds, preferredTimescale: 100)
        trackPlayer.seek(to: time)
    }
    
    @IBAction func togglePlayButton(_ sender: UIButton) {
        if trackPlayer.isPlaying {
            trackPlayer.pause()
        } else {
            trackPlayer.play()
        }
        updatePlayButton()
    }
    
    @IBAction func showScript(_ sender: Any) {
        let playerStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let scriptVC = playerStoryboard.instantiateViewController(identifier: "ScriptViewController") as? ScriptViewController else {
            return
        }
        scriptVC.script = self.script
        present(scriptVC, animated: true, completion: nil)
    }
    
    @IBAction func closeButtonToggled(_ sender: Any) {
        trackPlayer.replaceCurrentItem(with: nil)
        dismiss(animated: true, completion: nil)
    }
}

extension PlayerViewController {

    func secondsToString(sec: Double) -> String {
        guard sec.isNaN == false else { return "00:00" }
        let totalSeconds = Int(sec)
        let min = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", min, seconds)
    }
    
    func updateTime(time: CMTime) {
        currentTimeLabel.text = secondsToString(sec: trackPlayer.currentTime)
        remainingTimeLabel.text = "-" + secondsToString(sec: trackPlayer.remainingTime)
        
        if isSeeking == false {
            timeSlider.value = Float(trackPlayer.currentTime/trackPlayer.totalDurationTime)
        }
    }
    
    func updatePlayButton() {
        if trackPlayer.isPlaying {
            print("pause")
            let configuration = UIImage.SymbolConfiguration(pointSize: 40)
            let image = UIImage(systemName: "pause.fill", withConfiguration: configuration)
            playControlButton.setImage(image, for: .normal)
        } else {
            print("play")
            let configuration = UIImage.SymbolConfiguration(pointSize: 40)
            let image = UIImage(systemName: "play.fill", withConfiguration: configuration)
            playControlButton.setImage(image, for: .normal)
        }
    }
}

