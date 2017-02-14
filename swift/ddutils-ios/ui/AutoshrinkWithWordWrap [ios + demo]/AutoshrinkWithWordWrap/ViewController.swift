//
//  ViewController.swift
//  AutoshrinkWithWordWrap
//
//  Created by Dominik Pich on 14/02/2017.
//  Copyright © 2017 Dominik Pich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = "Some long text that contains a long word like 'Congratulations' which is shrunk but not splitted in between. The label honours\nthe Word-Wrap property."

        //add glow
        label.layer.shadowColor = UIColor.white.cgColor
        label.layer.shadowRadius = 20.0
        label.layer.shadowOpacity = 0.9
        label.layer.shadowOffset = CGSize.zero
        label.layer.masksToBounds = false
    }

    override func viewDidLayoutSubviews() {
        label.adjustFontSizeToFit(minFontSize: 10, maxFontSize: 120)
    }
}

