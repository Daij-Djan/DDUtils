//
//  ViewController.swift
//  HTMLHelpersDemo
//
//  Created by Dominik Pich on 10/12/16.
//  Copyright © 2016 Dominik Pich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for subview in view.subviews {
            switch subview {
            case let button as UIButton:
                button.setHTMLTitle(title: "<b>title</b> <i>string</i>", for: .normal)
                break
            case let lbl as UILabel:
                lbl.setHTMLText(text: "<h1>blablub</h1><p>aa</p><p>aaaa<b>aa</b>")
                break
            case let txt as UITextView:
                txt.setHTMLText(text: "<h1>blablub</h1><p>aa</p><a href=\"http://www.google.de\">google</a><p>aaaa<b>aa</b>")
                break
            default:
                break
            }
        }
    }
}

