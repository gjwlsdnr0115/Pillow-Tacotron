//
//  HomeViewController.swift
//  Pillow
//
//  Created by Jinwook Huh on 2020/12/20.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func cameraSelected(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        } else {
            print("Camera not available")
        }
    }
    
    @IBAction func photoSelected(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        picker.dismiss(animated: true, completion: nil)
        
        let playerStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let playerVC = playerStoryboard.instantiateViewController(identifier: "PlayerViewController") as? PlayerViewController else {
            return
        }
        
        var resultText = "none"
        CloudVisionOCR.shared.ocr(image: image) { result in
            resultText = result
        }

        guard resultText != "none" else {
            print("none")
            return
        }
        
        TacotronAPI.shared.speak(text: resultText) { resultTrack in
            playerVC.trackPlayer.replaceCurrentItem(with: resultTrack.audio)
            playerVC.script = resultTrack.script
            DispatchQueue.main.async {
                playerVC.activityIndicator.stopAnimating()
            }
            print("---> Done!")
        }

        playerVC.modalPresentationStyle = .fullScreen
        present(playerVC, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
