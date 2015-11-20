//
//  ImageViewController.swift
//  DDContentZoomSegueDemo
//
//  Created by Dominik Pich on 11/20/15.
//  Copyright © 2015 Dominik Pich. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    @IBAction func popOrDismiss(sender: AnyObject) {
        if let n = self.navigationController {
            n.popViewControllerAnimated(true)
        }
        else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
