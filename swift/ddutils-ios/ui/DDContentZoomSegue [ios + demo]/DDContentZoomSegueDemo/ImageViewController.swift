//
//  ImageViewController.swift
//  DDContentZoomSegueDemo
//
//  Created by Dominik Pich on 11/20/15.
//  Copyright © 2015 Dominik Pich. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    @IBAction func popOrDismiss(_ sender: AnyObject) {
        if let n = self.navigationController {
            n.popViewController(animated: true)
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
