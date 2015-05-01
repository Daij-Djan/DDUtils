//
//  NSView+allEnabled.swift
//  CoprightModifier
//
//  Created by Dominik Pich on 14/03/15.
//  Copyright (c) 2015 Dominik Pich. All rights reserved.
//

import Foundation

extension NSView {
    var allEnabled:Bool {
        get {
            for view in self.subviews as [NSView] {
                if view is NSControl {
                    if !(view as NSControl).enabled {
                        return false
                    }
                }

                if !view.allEnabled {
                    return false
                }
            }
            return true
        }
        set {
            for view in self.subviews as [NSView] {
                if view is NSControl {
                    (view as NSControl).enabled = newValue
                }

                view.allEnabled = newValue
            }
        }
    }
}