//
//  BSContentZoomSegue.swift
//  Boxenstopp
//
//  Created by Dominik Pich on 11/10/15.
//

import UIKit

class DDContentZoomSegue: UIStoryboardSegue {
    var sender: AnyObject?
    var modal = false
    var duration = 0.4
    
    override func perform() {
        //get views
        let sourceVCView = self.sourceViewController.view as UIView!
        let destVCView = self.destinationViewController.view as UIView!
        let window = UIApplication.sharedApplication().keyWindow
        
        //add a screenshot to cover for source view
        let snapView = UIScreen.mainScreen().snapshotViewAfterScreenUpdates(false)
        window!.insertSubview(snapView, aboveSubview: sourceVCView)
        
        // Get the screen width and height.
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
        destVCView.center = CGPointMake(screenWidth/2, screenHeight/2)

        var srcRect = CGRectMake(screenWidth/2-5, screenHeight/2-5,10,10)
        if let s = sender as? UIView {
            srcRect = s.convertRect(s.bounds, toView: nil)
        }
        
        var r = window!.bounds;
//        r.origin.y = 44;
//        r.size.height -= r.origin.y;

        //add the new view - without it, it has no animation layer
        window!.insertSubview(destVCView, aboveSubview: sourceVCView)
        destVCView.frame = r
        destVCView.alpha = 0
        destVCView.userInteractionEnabled = false

        //create mask
        let mask = CAShapeLayer()
        let path = CGPathCreateWithRect(srcRect, nil)
        mask.path = path
        destVCView.layer.mask = mask;
        
        //animate mask
        let newPath = CGPathCreateWithRect(destVCView.bounds, nil)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        CATransaction.setAnimationDuration(duration)
        CATransaction.setCompletionBlock { () -> Void in
            let navController = self.sourceViewController.navigationController;
            if(!self.modal && navController != nil) {
                navController!.pushViewController(self.destinationViewController, animated: false)
            }
            else {
                self.sourceViewController.presentViewController(self.destinationViewController, animated: false, completion: nil)
            }
            
            let destVCView = self.destinationViewController.view as UIView!
            destVCView.userInteractionEnabled = true
            snapView.removeFromSuperview()
        }
        let revealAnimation = CABasicAnimation(keyPath: "path")
        revealAnimation.fromValue = path
        revealAnimation.toValue = newPath
        mask.addAnimation(revealAnimation, forKey: "revealAnimation")
        mask.path = newPath //avoid 'snap back'
        CATransaction.commit()
        
        // Animate the tranistion
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            destVCView.alpha = 1
            }) { (Finished) -> Void in
        }
        
    }
}
