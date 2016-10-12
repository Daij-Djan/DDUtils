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
        let sourceVCView = self.source.view as UIView!
        let destVCView = self.destination.view as UIView!
        let window = UIApplication.shared.keyWindow
        
        //add a screenshot to cover for source view
        let snapView = UIScreen.main.snapshotView(afterScreenUpdates: false)
        window!.insertSubview(snapView, aboveSubview: sourceVCView!)
        
        // Get the screen width and height.
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        
        destVCView?.center = CGPoint(x: screenWidth/2, y: screenHeight/2)

        var srcRect = CGRect(x: screenWidth/2-5, y: screenHeight/2-5,width: 10,height: 10)
        if let s = sender as? UIView {
            srcRect = s.convert(s.bounds, to: nil)
        }
        
        let r = window!.bounds;
//        r.origin.y = 44;
//        r.size.height -= r.origin.y;

        //add the new view - without it, it has no animation layer
        window!.insertSubview(destVCView!, aboveSubview: sourceVCView!)
        destVCView?.frame = r
        destVCView?.alpha = 0
        destVCView?.isUserInteractionEnabled = false

        //create mask
        let mask = CAShapeLayer()
        let path = CGPath(rect: srcRect, transform: nil)
        mask.path = path
        destVCView?.layer.mask = mask;
        
        //animate mask
        let newPath = CGPath(rect: (destVCView?.bounds)!, transform: nil)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        CATransaction.setAnimationDuration(duration)
        CATransaction.setCompletionBlock { () -> Void in
            let navController = self.source.navigationController;
            if(!self.modal && navController != nil) {
                navController!.pushViewController(self.destination, animated: false)
            }
            else {
                self.source.present(self.destination, animated: false, completion: nil)
            }
            
            let destVCView = self.destination.view as UIView!
            destVCView?.isUserInteractionEnabled = true
            snapView.removeFromSuperview()
        }
        let revealAnimation = CABasicAnimation(keyPath: "path")
        revealAnimation.fromValue = path
        revealAnimation.toValue = newPath
        mask.add(revealAnimation, forKey: "revealAnimation")
        mask.path = newPath //avoid 'snap back'
        CATransaction.commit()
        
        // Animate the tranistion
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            destVCView?.alpha = 1
            }, completion: { (Finished) -> Void in
        }) 
        
    }
}
