//
//  html.swift
//  LHWalkthroughLounge
//
//  Created by Dominik Pich on 9/2/16.
//
//

import UIKit

public extension UIButton {
    public func setHTMLTitle(title: NSString?, for state: UIControlState) {
        guard let title = title else {
            setTitle(nil, for: state)
            return
        }
        
        guard let titleLabel = titleLabel else {
            setTitle(nil, for: state)
            return
        }
        
        if titleLabel.font == nil {
            titleLabel.font = UIFont.systemFont(ofSize:UIFont.systemFontSize)
        }
        
        var c = titleColor(for: state)
        if c == nil {
            c = UIColor.black
            setTitleColor(c, for: state)
        }
        
        setAttributedTitle(html(html: title, font: titleLabel.font, color: c!), for: state)
    }
}

public extension UILabel {
    public func setHTMLText(text: NSString?) {
        guard let text = text else {
            attributedText = nil
            return
        }

        if font == nil {
            font = UIFont.systemFont(ofSize:UIFont.systemFontSize)
        }
        if textColor == nil {
            textColor = UIColor.black
        }

        attributedText = html(html: text, font: font, color: textColor)
    }
}

public extension UITextView {
    public func setHTMLText(text: NSString?) {
        guard let text = text else {
            attributedText = nil
            return
        }

        if font == nil {
            font = UIFont.systemFont(ofSize:UIFont.systemFontSize)
        }
        if textColor == nil {
            textColor = UIColor.black
        }

        attributedText = html(html: text, font:font!, color:textColor!)
    }
}

//shared helpers

private func html(html:NSString, font:UIFont, color:UIColor) -> NSAttributedString {
    let colorName = colorToHexString(color: color)
    let fontName = font.fontName
    let fontSize = font.pointSize
    
    let style = "<style>body{color: \(colorName); font-family: '\(fontName)'; font-size:\(fontSize)px;}</style>"
    let htmlString = html.appending(style)
    let d = htmlString.data(using: String.Encoding.utf8)!
    
    let o = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType as AnyObject, NSCharacterEncodingDocumentAttribute: NSNumber(value: String.Encoding.utf8.rawValue) as AnyObject] as [String:AnyObject]
    
    do {
        let attrStr = try NSAttributedString(data:d, options:o, documentAttributes:nil)
        return attrStr
    }
    catch {
        return NSAttributedString(string: "")
    }
}

private func colorToHexString(color: UIColor) -> String {
    var r:CGFloat = 0
    var g:CGFloat = 0
    var b:CGFloat = 0
    var a:CGFloat = 0
    
    color.getRed(&r, green: &g, blue: &b, alpha: &a)
    
    let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
    
    return String(format:"#%06x", rgb)
}
