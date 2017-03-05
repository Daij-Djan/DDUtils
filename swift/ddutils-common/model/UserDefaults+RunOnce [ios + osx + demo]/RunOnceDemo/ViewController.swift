//
//  ViewController.swift
//  RunOnceDemo
//
//  Created by Dominik Pich on 10/12/16.
//  Copyright © 2016 Dominik Pich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let run = UserDefaults.standard.runOnce(key: "first") { () -> Bool in
            self.view.backgroundColor = UIColor.red
            print("first run ONLY")
            
            return false //dont run again
        }
        
        if(!run) {
            //all but first
            self.view.backgroundColor = UIColor.green
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

