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

        let delayTime1 = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime1) {
            self.slider1.sliderValue = 0.7;
        }
        
        let delayTime2 = DispatchTime.now() + Double(Int64(1.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime2) {
            self.slider2.sliderValue = 0.4;
        }

        let delayTime3 = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime3) {
            self.slider3.sliderValue = 1;
        }

        let delayTime4 = DispatchTime.now() + Double(Int64(2.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime4) {
            self.slider4.sliderValue = 0.6;
        }
    }
}

