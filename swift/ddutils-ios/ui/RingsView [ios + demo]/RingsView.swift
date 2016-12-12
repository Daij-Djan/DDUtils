//
//  RingsView.swift
//  RingsView
//
//  Created by Dominik Pich on 8/26/16.
//  Copyright © 2016 Dominik Pich. All rights reserved.
//

import UIKit
import QuartzCore

@IBDesignable
class RingsView: UIView, CAAnimationDelegate {
    @IBInspectable var ringsColor:UIColor = UIColor.white
    @IBInspectable var durationMS:Int = 3000
    var duration : Double { return Double(durationMS) / 1000.0 }
    @IBInspectable var overlapMS:Int = 1500
    var overlap : Double { return Double(overlapMS) / 1000.0 }
    @IBInspectable var distance:Int = 20
    @IBInspectable var move:Int = 18
    @IBInspectable var thickness:Int = 4
    
    private lazy var circleShapes: [Int:(CAShapeLayer, CAAnimationGroup?)] = {
        let ls: [Int:(CAShapeLayer, CAAnimationGroup?)]
            
        ls = [1:(CAShapeLayer(),nil), 2:(CAShapeLayer(),nil), 3:(CAShapeLayer(),nil)]
        
        for idx in [1,2,3] {
            let v = ls[idx]!
            self.layer.addSublayer(v.0)
        }
        return ls
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //see what we gotta keep
        var innerRadius = CGFloat(1)
        if let subview = subviews.first {
            innerRadius = max(subview.frame.width, subview.frame.height) / 2 + CGFloat(distance)
            if(innerRadius < 1) {
                innerRadius = 1
            }
        }
        
        let centerBounds = CGPoint(x: bounds.width/2, y: bounds.height/2)
        var targetRadius = innerRadius
        var pastDuration = 0.0
        let currentTime = layer.convertTime(CACurrentMediaTime(), from: nil)

        //position them all
        for idx in [1,2,3] {
            let v = circleShapes[idx]!
            let circleShape = v.0
            
            let centerOffset = innerRadius+layer.cornerRadius
            let pathFrame = CGRect(x: centerBounds.x - centerOffset,
                                   y: centerBounds.y - centerOffset,
                                   width: centerOffset*2,
                                   height: centerOffset*2)
            let shapePosition = CGPoint(x: 0, y: 0)
            let bezierPath = UIBezierPath(roundedRect: pathFrame, cornerRadius:pathFrame.width/2)
            
            circleShape.path = bezierPath.cgPath
            circleShape.position = shapePosition
            circleShape.fillColor = UIColor.clear.cgColor
            circleShape.strokeColor = ringsColor.cgColor
            circleShape.lineWidth = CGFloat(thickness)
            circleShape.opacity = 0
            
            innerRadius += CGFloat(distance)
        }
        
        //prepare to animate bigger & fade in
        for idx in [1,2,3] {
            let v = circleShapes[idx]!
            let circleShape = v.0
            
            circleShape.removeAllAnimations()
            
            let centerOffset = targetRadius+layer.cornerRadius+CGFloat(move)
            let pathFrame = CGRect(x: centerBounds.x - centerOffset,
                                   y: centerBounds.y - centerOffset,
                                   width: centerOffset*2,
                                   height: centerOffset*2)
            let bezierPath = UIBezierPath(roundedRect: pathFrame, cornerRadius:pathFrame.width/2)
            
            let pathAni = basicAnimationWithKeyPath("path", toValue: bezierPath.cgPath, duration: duration)
            let fadeAni = basicAnimationWithKeyPath("opacity", toValue: 1 as AnyObject!, duration: duration/1.8)
            fadeAni.autoreverses = true
            let groupAni = animationGroupWithArray([pathAni, fadeAni], duration: duration)
            groupAni.beginTime = currentTime + (pastDuration > 0 ? pastDuration - overlap : 0.1)
            groupAni.delegate = self
            
            groupAni.setValue(idx, forKey: "idx")
//            circleShape.addAnimation(groupAni, forKey: "moveAndFade")

            targetRadius += CGFloat(distance)
            
            pastDuration += duration
            
            circleShapes[idx] = (circleShape, groupAni)
        }
        
        animateAllOnce()
    }
    
    func animateAllOnce() {
        let currentTime = layer.convertTime(CACurrentMediaTime(), from: nil)

        for idx in [1,2,3] {
            let v = circleShapes[idx]!
            let circleShape = v.0
            let groupAni = v.1!
            
            if(idx>1) {
                groupAni.beginTime = currentTime + ((duration-overlap) * Double(idx - 1))
            }
            else {
                groupAni.beginTime = currentTime + 0.1
            }
            circleShape.add(groupAni, forKey: "moveAndFade")
        }
    }
    
    //could be in categories but I want this self contained
    // ...and they might be a tick too specific!?
    
    func animationGroupWithArray(_ animations:[CAAnimation], duration:CFTimeInterval) -> CAAnimationGroup {
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = animations
        animationGroup.duration = duration
        animationGroup.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn)
        return animationGroup
    }
    
    func basicAnimationWithKeyPath(_ keyPath:String, toValue:AnyObject!, duration:CFTimeInterval) -> CABasicAnimation {
        let basicAnimation = CABasicAnimation(keyPath: keyPath)
        basicAnimation.toValue = toValue
        basicAnimation.duration = duration
        basicAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        return basicAnimation
    }

    //delegate
    
    func animationDidStop(_ anim: CAAnimation, finished: Bool) {
        DispatchQueue.main.async {
            guard finished else {
                return
            }
            
            guard let idx = anim.value(forKey: "idx") as? Int else {
                return
            }
            
            if idx == 3 {
                self.animateAllOnce()
            }
        }
    }
}
