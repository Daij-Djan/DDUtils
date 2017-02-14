//
//  AutoshrinkWithWordWrap.swift
//
//  Created by Dominik Pich on 13/02/2017.
//  Copyright © 2017 Dominik Pich. All rights reserved.
//

import UIKit

//this  keepss proper word wrap!
extension UILabel {
    func adjustFontSizeToFit(minFontSize: CGFloat, maxFontSize: CGFloat) {
        let originalFont = font ?? UIFont.systemFont(ofSize: maxFontSize)
        let originalStr = text ?? ""
        let originalWidth = frame.width
        let originalHeight = frame.height
        
        //the perfect font size
        var bestSize = maxFontSize
        
        //find the font size that wont break the longest DRAWN word
        let words = originalStr.components(separatedBy: " ")
        for word in words {
            let rectSizeAndFontSize = word.measurements(font:originalFont,
                                                        minFontSize:minFontSize,
                                                        maxFontSize:bestSize,
                                                        maxWidth: originalWidth)
            bestSize = rectSizeAndFontSize.1
        }
        
        let constraint = CGSize(width: CGFloat(originalWidth), height: CGFloat(MAXFLOAT))
        let rectSizeAndFontSize = originalStr.measurements(font:originalFont,
                                                           minFontSize:minFontSize,
                                                           maxFontSize:bestSize,
                                                           maxHeight:originalHeight,
                                                           constraintSize:constraint)
        bestSize = rectSizeAndFontSize.1
        
        //apply font
        font = originalFont.withSize(bestSize)
    }
}

extension String {
    func measurements(font:UIFont, minFontSize: CGFloat, maxFontSize: CGFloat, maxWidth maybeMaxWidth:CGFloat? = nil, maxHeight maybeMaxHeight:CGFloat? = nil, constraintSize maybeConstraintSize:CGSize? = nil) -> (CGSize, CGFloat) {
        let maxWidth = maybeMaxWidth ?? CGFloat(MAXFLOAT)
        let maxHeight = maybeMaxHeight ?? CGFloat(MAXFLOAT)
        let constraintSize = maybeConstraintSize ?? CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT))
        
        //prepare paragraph that wont change
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        paragraph.alignment = .center
        
        for size in stride(from: maxFontSize, to: minFontSize, by: -CGFloat(0.1)) {
            //prepare attributes
            let proposedFont = font.withSize(size)
            let attribs: [String:Any] = [NSFontAttributeName: proposedFont, NSParagraphStyleAttributeName: paragraph]
            
            let labelSize = self.boundingRect(with: constraintSize,
                                              options: .usesLineFragmentOrigin,
                                              attributes: attribs,
                                              context: nil)
            
            if labelSize.width < maxWidth && labelSize.height < maxHeight {
                return (labelSize.size, size)
            }
        }
        
        return (CGSize.zero, 0)
    }
}
