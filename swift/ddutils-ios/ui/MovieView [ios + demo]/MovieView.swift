//
//  MovieView.swift
//  LHWalkthroughLounge
//
//  Created by Dominik Pich on 8/24/16.
//
//

import UIKit
import AVFoundation

@IBDesignable class MovieView : UIView {
    @IBInspectable var movieAssetName: String! {
        didSet {
            self.playerLayer = createPlayerLayer(movieAssetName: movieAssetName)
        }
    }
    
    var playerLayer:AVPlayerLayer? {
        willSet {
            if let playerLayer = playerLayer {
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
                
                playerLayer.removeFromSuperlayer()
            }
        }
        didSet {
            if let playerLayer = playerLayer {
                NotificationCenter.default.addObserver(self, selector:#selector(playerDidReachEnd), name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:nil)
                
                playerLayer.frame = self.bounds
                layer.addSublayer(playerLayer)
                playerLayer.player?.isMuted = true
                playerLayer.player?.play()
            }
        }
    }
    
    private func createPlayerLayer(movieAssetName:String)->AVPlayerLayer? {
        var movieURL:URL!
        let bundle = Bundle.main
        
        //try iphone vs. ipad
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            movieURL = bundle.url(forResource: movieAssetName + "-ipad", withExtension: "mov")
            if movieURL == nil {
                movieURL = bundle.url(forResource: movieAssetName + "-ipad", withExtension: "m4v")
            }
        }
        else {
            movieURL = bundle.url(forResource: movieAssetName + "-iphone", withExtension: "mov")
            if movieURL == nil {
                movieURL = bundle.url(forResource: movieAssetName + "-iphone", withExtension: "m4v")
            }
        }
        
        //universal
        if movieURL == nil {
            movieURL = bundle.url(forResource: movieAssetName, withExtension: "mov")
            if movieURL == nil {
                movieURL = bundle.url(forResource: movieAssetName, withExtension: "m4v")
            }
        }
        
        //check if we have the movie
        guard movieURL != nil else {
            return nil
        }
        
        //prepare player
        let player = AVPlayer(url: movieURL)
        player.allowsExternalPlayback = false
        player.appliesMediaSelectionCriteriaAutomatically = false
        
        // This is needed so it would not cut off users audio (if listening to music etc.
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        } catch let error1 as NSError {
            print(error1)
        } catch {
            fatalError()
        }
        
        //make layer and start it
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = "AVLayerVideoGravityResizeAspectFill"
        playerLayer.backgroundColor = UIColor.black.cgColor
        
        return playerLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = self.bounds
    }
    
    func playerDidReachEnd(notification: NSNotification) {
        guard let player = self.playerLayer?.player else {
            return
        }
        player.seek(to: kCMTimeZero)
        player.play()
        
    }
}
