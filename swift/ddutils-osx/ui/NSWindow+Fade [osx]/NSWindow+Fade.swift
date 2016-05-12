//
//  NSWindow+Fade.swift
//
//  Created by Dominik Pich on 4/27/16.
//  Copyright © 2016 Dominik Pich. All rights reserved.
//

import Cocoa

let kWindowFadeAnimationDuration = 0.1

extension NSWindow /*(Fade)*/ {
    func fadeInWithDuration(duration: NSTimeInterval) {
        alphaValue = 0
        makeKeyAndOrderFront(nil)
        
        NSAnimationContext.beginGrouping()
        NSAnimationContext.currentContext().duration = duration
        animator().alphaValue = 1
        NSAnimationContext.endGrouping()
    }
    
    @IBAction func fadeIn(sender: AnyObject!) {
        fadeInWithDuration(kWindowFadeAnimationDuration)
    }
    
    func fadeOutWithDuration(duration: NSTimeInterval) {
        NSAnimationContext.beginGrouping()
        NSAnimationContext.currentContext().duration = duration
        NSAnimationContext.currentContext().completionHandler = {
            self.orderOut(nil)
            self.alphaValue = 1
        }
        animator().alphaValue = 0
        NSAnimationContext.endGrouping()
    }
    
    @IBAction func fadeOut(sender: AnyObject!) {
        fadeOutWithDuration(kWindowFadeAnimationDuration)
    }
}