//
//  TacotronAPI.swift
//  Pillow
//
//  Created by Jinwook Huh on 2020/12/20.
//

import UIKit
import AVFoundation

let ttsAPIUrl = "http://34.70.128.77:10001/api/text/getText"

class TacotronAPI: NSObject, AVAudioPlayerDelegate {

    static let shared = TacotronAPI()
    private(set) var busy: Bool = false
        
    func speak(text: String, completion: @escaping (Track) -> Void) {
        guard !self.busy else {
            print("API busy!")
            return
        }
        
        self.busy = true
        
        DispatchQueue.global(qos: .background).async {
            let postData = self.buildPostData(text: text)
            let dataString = String(decoding: postData, as: UTF8.self)
            print("---> \(dataString)")
            let response = self.makePOSTRequest(url: ttsAPIUrl, postData: postData)

            let audioContent = self.parseAnnotations(response)
            guard audioContent != "error" else {
                print("Invalid encoded string")
                self.busy = false

                return
            }
            
            guard let audioData = Data(base64Encoded: audioContent) else {
                self.busy = false

                return
            }
            
            let tmpFileURL = URL(fileURLWithPath:NSTemporaryDirectory()).appendingPathComponent("output").appendingPathExtension("mp3")
            _ = (try? audioData.write(to: tmpFileURL, options: [.atomic])) != nil
            
            let item = AVPlayerItem(url: tmpFileURL)
            let testTrack = Track(file: item, text: text)
            self.busy = false
            completion(testTrack)
        }
    }

    private func buildPostData(text: String) -> Data {
        
        let requestText = text.replacingOccurrences(of: "\n", with: " ")
        let textObj = TextObj(load_path: "logs/", text: requestText, num_speakers: "3", speaker_id: Speaker.shared.speakerId)
        let encoder = JSONEncoder()
        let jsonData = try! encoder.encode(textObj)

        return jsonData
    }
    
    private func makePOSTRequest(url: String, postData: Data) -> Data {
        var resultData = Data()
        
        var request = URLRequest(url: URL(string: url)!)
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData

        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                resultData = data
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        return resultData
    }
    
    
    private func parseAnnotations(_ data: Data) -> String {
        let decoder = JSONDecoder()
        
        do {
            let response = try decoder.decode(TTSResponse.self, from: data)
            let audioContent = response.data
            return audioContent
        } catch let error {
            print("---> errort: \(error)")
            return "error"
        }
    }
}

struct TextObj: Codable {
    let load_path: String
    let text: String
    let num_speakers: String
    let speaker_id: String
}

struct TTSResponse: Codable {
    let data: String

    enum CodingKeys: String, CodingKey {
        case data = "Data"
    }
}

