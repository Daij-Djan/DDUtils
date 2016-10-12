//
//  UIStackView+makeScrollable.swift
//  LHWalkthroughLounge
//
//  Created by Dominik Pich on 9/1/16.
//
//
import UIKit

class ScrollingStackView : UIStackView {
    override func layoutSubviews() {
        makeScrollable()
    }
    
    func makeScrollable() {
        guard let view = self.superview else {
            //print("StackView must belong to a view to make scrollable")
            return
        }
        
        guard !(view is UIScrollView) else {
            //print("already in a scrollview, quit")
            return
        }
        
        let scrollView = UIScrollView(frame: self.frame)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        var constraintsToAdd = [NSLayoutConstraint]()
        var constraintsToDelete = [NSLayoutConstraint]()
        
        for constraint in view.constraints {
            var item = constraint.firstItem
            var toItem = constraint.secondItem
            var replace = false

            if(item as? UIStackView) == self {
                item = scrollView
                replace = true
            }
            if(toItem as? UIStackView) == self {
                toItem = scrollView
                replace = true
            }
            
            if(replace) {
                let new = NSLayoutConstraint(item: item, attribute: constraint.firstAttribute, relatedBy: constraint.relation, toItem: toItem, attribute: constraint.secondAttribute, multiplier: constraint.multiplier, constant: constraint.constant)
                constraintsToAdd.append(new)
                constraintsToDelete.append(constraint)
            }
        }
        NSLayoutConstraint.deactivate(constraintsToDelete)
        NSLayoutConstraint.activate(constraintsToAdd)
        
        self.removeFromSuperview()
        scrollView.addSubview(self)
        
        //axis
        if self.axis == .vertical {
            scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[stackView(==scrollView)]", options: .alignAllCenterX, metrics: nil, views: ["stackView": self, "scrollView": scrollView]))
        }
        else {
            scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[stackView(==scrollView)]", options: .alignAllCenterX, metrics: nil, views: ["stackView": self, "scrollView": scrollView]))
        }
        
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackView]|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: ["stackView": self]))
         scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[stackView]|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: ["stackView": self]))
    }
}
