//
//  HomeViewController.swift
//  DDContentZoomSegueDemo
//
//  Created by Dominik Pich on 11/20/15.
//  Copyright © 2015 Dominik Pich. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class HomeViewController: UIViewController {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let s = segue as? DDContentZoomSegue {
            s.modal = (segue.identifier?.hasPrefix("Present"))!
            s.sender = sender
            s.duration = 2
        }
    }
}

