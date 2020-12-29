//
//  CloudVisionOCR.swift
//  Pillow
//
//  Created by Jinwook Huh on 2020/12/20.
//

import UIKit
import AVFoundation

let ocrAPIUrl = "https://vision.googleapis.com/v1/images:annotate"
let ocrAPIKey = "AIzaSyBVTTFRvfsxCAp-yHJymXImBvAx4wQUH1s"

class CloudVisionOCR: NSObject, AVAudioPlayerDelegate {

    static let shared = CloudVisionOCR()
    private(set) var busy: Bool = false
        
    func ocr(image: UIImage, completion: @escaping (String) -> Void){
        guard !self.busy else {
            print("Speech Service busy!")
            return
        }
        
        self.busy = true
        
        DispatchQueue.global(qos: .background).sync {
            let postData = self.buildPostData(image: image)
            let headers = ["X-Goog-Api-Key": ocrAPIKey, "Content-Type": "application/json; charset=utf-8"]
            let response = self.makePOSTRequest(url: ocrAPIUrl, postData: postData, headers: headers)

            let annotations = self.parseAnnotations(response)
            let resultText = annotations[0].description
            self.busy = false
            
            completion(resultText)
        }
    }
    
    private func buildPostData(image: UIImage) -> Data {
        
        let imageData = image.jpegData(compressionQuality: 1)
        let imageBase64 = imageData?.base64EncodedString() ?? "not converted"

        let typeObj = TypeObj(type: "DOCUMENT_TEXT_DETECTION")
        let imageObj = ImageObj(content: imageBase64)
        let paramsObj = ParamsObj(image: imageObj, features: [typeObj])
        let requestsObj = RequestsObj(requests: [paramsObj])
        
        let encoder = JSONEncoder()
        let jsonData = try! encoder.encode(requestsObj)

        return jsonData
    }
    
    private func makePOSTRequest(url: String, postData: Data, headers: [String: String] = [:]) -> Data {
        var jsonData: Data = Data()
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.httpBody = postData

        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                jsonData = data
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        return jsonData
    }
    
    
    
    private func parseAnnotations(_ data: Data) -> [Annotation] {
        let decoder = JSONDecoder()
        
        do {
            let response = try decoder.decode(Response.self, from: data)
            let annotations = response.annotations[0].texts
            return annotations
            
        } catch let error {
            print("---> error: \(error)")
            return []
        }
    }
}

struct ImageObj: Codable {
    let content: String
}

struct TypeObj: Codable {
    let type: String
}

struct ParamsObj: Codable {
    let image: ImageObj
    let features: [TypeObj]
}

struct RequestsObj: Codable {
    let requests: [ParamsObj]
}


struct Response: Codable {
    let annotations: [Text]
    
    enum CodingKeys: String, CodingKey {
        case annotations = "responses"
    }
}

struct Text: Codable {
    let texts: [Annotation]

    enum CodingKeys: String, CodingKey {
        case texts = "textAnnotations"
    }
}

struct Annotation: Codable {
    let description: String
}

