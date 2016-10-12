//
//  ViewController.swift
//  ScrollingStackViewDemo
//
//  Created by Dominik Pich on 9/1/16.
//  Copyright © 2016 Dominik Pich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var sv1: ScrollingStackView!
    @IBOutlet weak var sv2: ScrollingStackView!
    @IBOutlet weak var sv3: ScrollingStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 1 ..< 3 {
            let vw = UIButton(type: UIButtonType.system)
            vw.setTitle("Button \(i)", for: UIControlState())
            sv1.addArrangedSubview(vw)
        }
        
        for i in 1 ..< 100 {
            let vw = UIButton(type: UIButtonType.system)
            vw.setTitle("Button \(i)", for: UIControlState())
            sv2.addArrangedSubview(vw)
        }
        for i in 1 ..< 100 {
            let vw = UIButton(type: UIButtonType.system)
            vw.setTitle("Button \(i)", for: UIControlState())
            sv3.addArrangedSubview(vw)
        }
    }
}

