//
//  AppDelegate.swift
//  GoogleSpeechSessionOSXDemo
//
//  Created by Dominik Pich on 04/03/2017.
//  Copyright © 2017 Kuragin Dmitriy. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    
    @IBOutlet weak var recordBtn: NSButton!
    @IBOutlet weak var playBtn: NSButton!
    @IBOutlet weak var cancelBtn: NSButton!
    @IBOutlet weak var sendBtn: NSButton!
    @IBOutlet var textView: NSTextView!
    
    var googleSpeechSession = GoogleSpeechSession(languageCode: "de-DE")
    
    @IBAction func recordAudio(_ sender: AnyObject) {
        stopAudio(sender)
        
        googleSpeechSession.recordNewAudio { (started) in
            self.window.backgroundColor = started ? .red : .white
            
            self.recordBtn.isHidden = true
            self.playBtn.isHidden = false
            self.cancelBtn.isHidden = false
            self.sendBtn.isHidden = false
        }
    }
    
    @IBAction func playAudio(_ sender: AnyObject) {
        googleSpeechSession.playCachedAudio { (started) in
            self.window.backgroundColor = started ? .green : .white
        }
    }
    
    @IBAction func stopAudio(_ sender: AnyObject) {
        googleSpeechSession.stopAllAudio()
        self.window.backgroundColor = .white
        
        self.recordBtn.isHidden = false
        self.playBtn.isHidden = true
        self.cancelBtn.isHidden = true
        self.sendBtn.isHidden = true
    }
    
    @IBAction func processAudio(_ sender: AnyObject) {
        self.recordBtn.isHidden = true
        self.playBtn.isHidden = true
        self.cancelBtn.isHidden = true
        self.sendBtn.isHidden = true
        
        self.window.backgroundColor = .blue
        googleSpeechSession.send { (text, confidence) in
            self.window.backgroundColor = .white
            if let text = text,
                let confidence = confidence {
                self.textView.string = "=> \(text)\nconfidence: \(confidence)"
            }
            self.recordBtn.isHidden = false
        }
    }

    //MARK: AppDelegate

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

