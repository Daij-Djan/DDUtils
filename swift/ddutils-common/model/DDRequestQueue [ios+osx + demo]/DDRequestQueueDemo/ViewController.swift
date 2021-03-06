//
//  ViewController.swift
//  ModifiedSinceDemo
//
//  Created by Dominik Pich on 12/07/15.
//  Copyright (c) 2015 Dominik Pich. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DDRequestQueueDelegate {

    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        let queue = DDRequestQueue.defaultQueue
        assert(queue.suspended)
        queue.delegate = self;
        
        textView.text = ""
        
        textView.text! += "load suspended queue:\n"
        textView.text! += queue.queuedRequests.description
        
        queue.enqueueRequest(makeRequestTo("https://www.google.de"))
        queue.enqueueRequest(makeRequestTo("https://www.facebook.com"))
        queue.enqueueRequest(makeRequestTo("https://www.stackoverflow.com"))
        queue.enqueueRequest(makeRequestTo("http://www.pich.info"))
        
        textView.text! += "enqueued requests:\n"
        textView.text! += queue.queuedRequests.description

        textView.text! += "unsuspend. do requests but sleep 3s in between:\n"

        queue.suspended = false
    }
    
    fileprivate func makeRequestTo(_ urlString: String) -> URLRequest! {
        return URLRequest(url: URL(string: urlString)!)
    }
    
    //MARK: queue delegate
    
    func requestQueueWillStartRequest(_ queue: DDRequestQueue, request: URLRequest) {
        textView.text! += "start request \(request.url!)\n"
    }
    
    func requestQueueDequeuedRequest(_ queue: DDRequestQueue, request: URLRequest, response: URLResponse?, data: Data?, error: NSError?) {
        textView.text! += "finished request \(request.url!)\n"
        textView.text! += "sleep 3s\n"
        
        let target = Date().addingTimeInterval(3.0)
        RunLoop.current.run(until: target)
    }
    
    func requestQueueBeginWaitingForNetwork(_ queue: DDRequestQueue, host: String) {
        textView.text! += "begin waiting for network for \(host)\n"
    }

    func requestQueueEndWaitingForNetwork(_ queue: DDRequestQueue, host: String) {
        textView.text! += "done waiting for network for \(host)\n"
    }
}

