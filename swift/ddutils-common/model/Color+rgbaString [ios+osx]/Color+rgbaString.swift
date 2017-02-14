//
//  Color+rgbaString.swift
//
//  Created by Dominik Pich on 04/01/2017.
//  Copyright © 2017 Dominik Pich. All rights reserved.
//
#if os(iOS)
    import UIKit
    typealias Color = UIColor
#else
    import AppKit
    typealias Color = NSColor
#endif

extension Color {
    func rgbaString() -> String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return "\(red),\(green),\(blue),\(alpha)"
    }
    
    public convenience init?(rgbaString: String) {
        var red: Float = 0
        var green: Float = 0
        var blue: Float = 0
        var alpha: Float = 1
        
        let scanner = Scanner(string: rgbaString)
        scanner.scanFloat(&red)
        scanner.scanString(",", into: nil)
        scanner.scanFloat(&green)
        scanner.scanString(",", into: nil)
        scanner.scanFloat(&blue)
        scanner.scanString(",", into: nil)
        scanner.scanFloat(&alpha)
        
        self.init(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }
}
