//
//  ViewController.swift
//  DDSlidingImageView
//
//  Created by Dominik Pich on 29/04/15.
//  Copyright (c) 2015 Dominik Pich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var slider1: DDSlidingImageView!
    @IBOutlet var slider2: DDSlidingImageView!
    @IBOutlet var slider3: DDSlidingImageView!
    @IBOutlet var slider4: DDSlidingImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let delayTime1 = dispatch_time(DISPATCH_TIME_NOW,
            Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime1, dispatch_get_main_queue()) {
            self.slider1.sliderValue = 0.7;
        }
        
        let delayTime2 = dispatch_time(DISPATCH_TIME_NOW,
            Int64(1.5 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime2, dispatch_get_main_queue()) {
            self.slider2.sliderValue = 0.4;
        }

        let delayTime3 = dispatch_time(DISPATCH_TIME_NOW,
            Int64(2 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime3, dispatch_get_main_queue()) {
            self.slider3.sliderValue = 1;
        }

        let delayTime4 = dispatch_time(DISPATCH_TIME_NOW,
            Int64(2.5 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime4, dispatch_get_main_queue()) {
            self.slider4.sliderValue = 0.6;
        }
    }
}

