//
//  ViewController.swift
//  ModifiedSinceDemo
//
//  Created by Dominik Pich on 12/07/15.
//  Copyright (c) 2015 Dominik Pich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var string = "\n\n"
        
        let urlString = "http://www.pich.info/testfile.txt";
        let url = NSURL(string: urlString)!
        
        var dataAndDate = NSURLConnection.cachedDataForModifiedSinceRequest(url)
        if(dataAndDate != nil){
            string += ("have cached data for \(url), cache is from \(dataAndDate!.date)\n\n")
            string += ("Starting modified since request with modDate: \(dataAndDate!.date)\n\n")
        }
        else {
            string += ("nothing cached locally\n\n");
            string += ("Starting modified since request with modDate: null\n\n");
        }
        
        NSURLConnection.doModifiedSinceRequestForURL(url, completionHandler: { (url, contentData, modificationDate, fromCache, error) -> Void in
            if(contentData != nil) {
                if(fromCache) {
                    if(error != nil) {
                        string += ("Got cached data, request finished error though: \(error)\n\n")
                    }
                    else {
                        string += ("Got cached data\n\n");
                    }
                }
                else {
                    string += ("Got new data from server, last modified at \(modificationDate)\n\n");
                }
            }
            else {
                string += ("Got no data. Request failed: \(error)\n\n");
            }
            
            self.textView.text = string
            
            //now go and try again to see all cached or modify the server to get fresh data
        })
    }
}

