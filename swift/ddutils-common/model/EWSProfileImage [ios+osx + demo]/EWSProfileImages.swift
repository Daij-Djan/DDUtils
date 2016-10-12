//
//  EWSProfileImages.swift
//
//  Created by Dominik Pich on 7/8/16.
//  Copyright © 2016 Dominik Pich. All rights reserved.
//

import UIKit

open class EWSProfileImages: NSObject, URLSessionDelegate {
    //our manager class
    open static var shared = EWSProfileImages()
    open var credentials:EWSProfileImagesCredentials!
    open var placeholder:UIImage?
    
    public init(credentials:EWSProfileImagesCredentials? = nil,
                placeholder:UIImage? = UIImage(named: "person")) {
        self.credentials = credentials
        self.placeholder = placeholder
    }
    

    //cache
    fileprivate var queuedCompletions = [String:[EWSProfileImageCompletionBlock]]()
    fileprivate var cache = [String:EWSProfileImage]()
    fileprivate lazy var session:Foundation.URLSession = {
        return Foundation.URLSession(configuration: URLSessionConfiguration.ephemeral, delegate: self, delegateQueue: OperationQueue.main)
    }()
    
    //MARK: image loading

    open func get(_ email : String, imageSize:EWSProfileImageSize = .big, completion:EWSProfileImageCompletionBlock? = nil) throws -> EWSProfileImage {
        guard Thread.isMainThread else {
            throw NSError(domain: "EWS", code: -1, userInfo: [NSLocalizedDescriptionKey: "EWSProfileImages class is only to be used on main thread. cant get image"])
        }

        guard credentials != nil else {
            throw NSError(domain: "EWS", code: 0, userInfo: [NSLocalizedDescriptionKey: "credentials for EWS not set. cant get image"])
        }
        
        //get cache object
        let key = "\(email)_\(imageSize.rawValue)"
        if cache[key] == nil {
            cache[key] = EWSProfileImage(email: email, size: imageSize, state: .new, image: placeholder)
        }
        let image = cache[key]!
        
        //enque pending completion
        if let completion = completion {
            if queuedCompletions[key] == nil {
                queuedCompletions[key] = [EWSProfileImageCompletionBlock]()
            }
            
            queuedCompletions[key]!.append(completion)
        }
        
        //load and handle completion
        try load(image, completion: { [unowned self](loadedImage) in
            guard let blocks = self.queuedCompletions[key] else {
                print("no queuedCompletions[key]? weird but we can ignore this")
                return
            }
            for block in blocks {
                block(loadedImage)
            }
            self.queuedCompletions[key] = nil
        })
        
        return image
    }
    
    fileprivate func load(_ image:EWSProfileImage, completion:EWSProfileImageCompletionBlock?) throws {
        if image.state == .loaded || image.state == .loading {
            DispatchQueue.main.async(execute: { 
                completion?(image)
            })
            return
        }
        
        let urlString = "https://\(credentials.host)/ews/Exchange.asmx/s/GetUserPhoto?email=\(image.email)&size=\(image.size.rawValue)"
        guard let imgURL = URL(string: urlString) else {
            throw NSError(domain: "EWS", code: 1, userInfo: [NSLocalizedDescriptionKey: "cant assemble imgURL from urlString '\(urlString)'. cant get image"])
        }
        
        image.state = .loading
        
        let request = URLRequest(url: imgURL)
        session.dataTask(with: request, completionHandler: { (data, response, error) in
            if (response as! HTTPURLResponse).statusCode == 200,
                let data = data,
                let img = UIImage(data: data) {
                image.state = .loaded
                image.image = img
            }
            else {
                image.state = .failed
            }
            completion?(image)
        }).resume()
    }
    
    // MARK: URLSessionDelegate
    
    open func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let authenticationMethod = challenge.protectionSpace.authenticationMethod
        
        if authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if challenge.protectionSpace.host == "webmail.sapient.com" {
                completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
            }
        } else {
            if challenge.previousFailureCount > 0 {
                print("Alert Please check the credential")
                completionHandler(Foundation.URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
            } else {
                let credentials = self.credentials
                let credential = URLCredential(user:(credentials?.username)!, password:(credentials?.password)!, persistence: .forSession)
                completionHandler(Foundation.URLSession.AuthChallengeDisposition.useCredential,credential)
            }
        }
    }
    
    //MARK: - objects & types
    
    public typealias EWSProfileImagesCredentials = (host:String, username:String, password:String)
    
    public enum EWSProfileImageSize: String {
        case small = "HR48x48"
        case regular = "HR360x360"
        case big = "HR648x648"
    }
    
    public enum EWSProfileImageState {
        case new
        case loading
        case failed
        case loaded
    }
    
    open class EWSProfileImage {
        open internal(set) var email : String
        open internal(set) var size : EWSProfileImageSize
        open internal(set) var state : EWSProfileImageState
        open internal(set) var image : UIImage?
        
        internal init( email : String, size : EWSProfileImageSize, state : EWSProfileImageState, image : UIImage?) {
            self.email = email
            self.size = size
            self.state = state
            self.image = image
        }
    }
    
    public typealias EWSProfileImageCompletionBlock = ((EWSProfileImage)->Void)
}
