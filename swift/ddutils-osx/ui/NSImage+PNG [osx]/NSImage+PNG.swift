//
//  NSImage+PNG.swift
//  FocusMode
//
//  Created by Dominik Pich on 5/8/16.
//  Copyright © 2016 Dominik Pich. All rights reserved.
//

import Cocoa

extension NSImage {
    var PNGRepresentation: NSData? {
        guard let tiffData = TIFFRepresentation else {
            return nil
        }
        guard let rep = NSBitmapImageRep(data: tiffData) else {
            return nil
        }
        
        return rep.representationUsingType(.NSPNGFileType, properties: [:])
    }
}
