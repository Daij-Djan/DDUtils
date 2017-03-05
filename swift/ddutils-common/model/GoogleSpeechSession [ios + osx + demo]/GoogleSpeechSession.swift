//
//  GoogleSpeechSession.swift
//  SiemonaDemo
//
//  Created by Dominik Pich on 03/03/2017.
//  Copyright © 2017 Kuragin Dmitriy. All rights reserved.
//

import AVFoundation

class GoogleSpeechSession: NSObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    private var audioRecorder : AVAudioRecorder!
    private var audioPlayer : AVAudioPlayer!
    let languageCode : String
    let apiKey : String
    
    private(set) var soundFileURL:URL = {
        let dirPaths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        let docsDir = dirPaths[0]
        let url = URL(fileURLWithPath: docsDir)
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        catch _ {
            
        }
        return url.appendingPathComponent("sound.caf")
    }()
    
    var hasCachedAudio: Bool {
        return FileManager.default.fileExists(atPath: soundFileURL.path)
    }
    
    //MARK: -
    
    convenience init(languageCode:String) {
        let maybeStr = Bundle.main.object(forInfoDictionaryKey: "GoogleSpeechApiKey") as? String
        if let apiKey = maybeStr, apiKey.characters.count > 0 {
            self.init(languageCode:languageCode, apiKey:apiKey)
        }
        else {
            fatalError("To use Google Cloud Speech API, you need an API Key. This contructor attempted to load a potential key from the main bundle's info.plist but could find one. Sign up on google and save it to the plist under the key 'GoogleSpeechApiKey'")
        }
        
    }
    
    init(languageCode:String, apiKey:String) {
        self.languageCode = languageCode
        self.apiKey = apiKey
    }
    
    deinit {
        //rm old file
        do {
            try FileManager.default.removeItem(at: soundFileURL)
        }
        catch _ {
            
        }
    }
    
    func recordNewAudio(_ completion: @escaping (Bool)->Void) {
        stopAllAudio()

        #if os(iOS) || os(watchOS) || os(tvOS)
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
                try audioSession.setActive(true)
                
                audioSession.requestRecordPermission { (allowed) in
                    if allowed {
                        self._recordNewAudio(completion)
                    }
                    else {
                        print("no rights")
                        completion(false)
                    }
                }
            }
            catch _ {
                completion(false)
            }
        #elseif os(OSX)
            self._recordNewAudio(completion)
        #else
            println("OMG, it's that mythical new Apple product!!!")
        #endif
    }
    
    private func _recordNewAudio(_ completion: @escaping (Bool)->Void) {
        //rm old file
        do {
            try FileManager.default.removeItem(at: soundFileURL)
        }
        catch _ {
            
        }
        
        //make one-time recorder for the file
        let recordSettings = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVEncoderBitRateKey: 16,
            AVNumberOfChannelsKey: 1,
            AVSampleRateKey: 16000,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue]
        
        do {
            audioRecorder = try AVAudioRecorder(url: soundFileURL, settings: recordSettings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            completion(true)
        }
        catch _ {
            completion(false)
        }
    }
    
    func playCachedAudio(_ completion: @escaping (Bool)->Void) {
        stopAllAudio()
        
        guard hasCachedAudio else {
            completion(false)
            return
        }
        
        #if os(iOS) || os(watchOS) || os(tvOS)
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSessionCategoryPlayback)
                try audioSession.setActive(true)
                
                self._playCachedAudio(completion)
            }
            catch _ {
                completion(false)
            }
        #elseif os(OSX)
            self._playCachedAudio(completion)
        #else
            println("OMG, it's that mythical new Apple product!!!")
        #endif
    }
    
    private func _playCachedAudio(_ completion: @escaping (Bool)->Void) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundFileURL)
            audioPlayer.delegate = self;
            audioPlayer.volume = 1.0;
            audioPlayer.play()
        
            completion(true)
        }
        catch _ {
            completion(false)
        }
    }
    
    func stopAllAudio() {
        if (audioRecorder != nil && audioRecorder.isRecording) {
            audioRecorder.stop()
        }
        else if (audioPlayer != nil && audioPlayer.isPlaying) {
            audioPlayer.stop()
        }
    }
    
    func send(_ completion: @escaping (String?, Double?)->Void) {
        stopAllAudio()
        
        var service = "https:/speech.googleapis.com/v1beta1/speech:syncrecognize"
        service.append("?key=")
        service.append(apiKey)
        
        let audioData = NSData(contentsOf: soundFileURL) as! Data
        let configRequest = ["encoding":"LINEAR16",
                             "sampleRate":16000,
                             "languageCode":languageCode,
                             "maxAlternatives":0] as [String : Any]
        let audioRequest = ["content":audioData.base64EncodedString()]
        let requestDictionary = ["config":configRequest,
                                 "audio":audioRequest]
        let requestData = try! JSONSerialization.data(withJSONObject: requestDictionary, options: .prettyPrinted)
        
        let url = URL(string: service)
        var request = URLRequest(url: url!)
        request.addValue(Bundle.main.bundleIdentifier!, forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestData
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if(data != nil && data!.count > 0) {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                        if json["results"] != nil {
                            let results = json["results"] as! NSArray
                            let res1 = results.firstObject as! NSDictionary
                            let alternatives = res1["alternatives"] as! NSArray
                            let alt1 = alternatives.firstObject as! NSDictionary
                            let txt = alt1["transcript"] as! String
                            let confidence = alt1["confidence"] != nil ? alt1["confidence"] as! NSNumber : 1
                            
                            completion(txt, confidence.doubleValue)
                        }
                        else {
                            completion(nil, nil)
                        }
                    }
                    catch _ {
                        completion(nil, nil)
                    }
                }
                else {
                    completion(nil, nil)
                }
            }
        }
        task.resume()
    }
}
