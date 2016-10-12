#if os(iOS)
    import UIKit
    #else
    import Foundation
    import CoreGraphics
#endif

class DDRectUtilities {

    #if os(iOS)
    class func adjustRectForViewContent(_ unscaledRect:CGRect, view:UIView) -> CGRect {
        let bounds = view.bounds;
        var rect = unscaledRect;
        switch (view.contentMode) {
        case UIViewContentMode.scaleToFill:
            return bounds;
            
        case UIViewContentMode.scaleAspectFit:
            return self.fitRect(rect, inRect:bounds);
            
        case UIViewContentMode.scaleAspectFill:
            return self.fillRect(rect, inRect:bounds);
            
        case UIViewContentMode.redraw:
            return rect;
            
        case UIViewContentMode.center:
            return self.centerRect(rect, inRect:bounds);
            
        case UIViewContentMode.top:
            rect.origin.y = bounds.origin.y;
            break;
            
        case UIViewContentMode.bottom:
            rect.origin.y = bounds.origin.y + bounds.size.height - rect.size.height;
            return rect;
            
        case UIViewContentMode.left:
            rect.origin.x = bounds.origin.x;
            return rect;
            
        case UIViewContentMode.right:
            rect.origin.x = bounds.origin.x + bounds.size.width - rect.size.width;
            return rect;
            
        case UIViewContentMode.topLeft:
            rect.origin.x = bounds.origin.x;
            rect.origin.y = bounds.origin.y;
            return rect;
            
        case UIViewContentMode.topRight:
            rect.origin.x = bounds.origin.x + bounds.size.width - rect.size.width;
            rect.origin.y = bounds.origin.y;
            return rect;
            
        case UIViewContentMode.bottomLeft:
            rect.origin.x = bounds.origin.x;
            rect.origin.y = bounds.origin.y + bounds.size.height - rect.size.height;
            return rect;
            
        case UIViewContentMode.bottomRight:
            rect.origin.x = bounds.origin.x + bounds.size.width - rect.size.width;
            rect.origin.y = bounds.origin.y + bounds.size.height - rect.size.height;
            return rect;
        }
        return rect;
    }
    #endif
    
    //MARK: -
    
    class func fitRect(_ rect:CGRect, inRect:CGRect) -> CGRect {
        var result = CGRect.zero;
        
        // Before dividing by zero, we better take ratios of 1.0
        
        var xRatio:CGFloat = 1.0;
        if(inRect.size.width != 0) {
            xRatio = rect.size.width / inRect.size.width;
        }
        
        var yRatio:CGFloat = 1.0;
        if(inRect.size.height != 0.0) {
            yRatio = rect.size.height / inRect.size.height;
        }
        
        var aspectRatio:CGFloat = 1.0;
        if(rect.size.height != 0.0) {
            aspectRatio = rect.size.width / rect.size.height;
        }
        
        //fit sizes
        if (xRatio >= yRatio && aspectRatio != 0.0) {
            result.size.width = inRect.size.width;
            result.size.height = result.size.width / aspectRatio;
        }
        else {
            result.size.height = inRect.size.height;
            result.size.width = result.size.height * aspectRatio;
        }
        
        //center rect
        result = self.centerRect(result, inRect:inRect);
        
        return result;
    }
    
    class func fillRect(_ rect:CGRect, inRect:CGRect) -> CGRect {
        var result = CGRect.zero;
        
        var xRatio:CGFloat = 1.0;
        if(inRect.size.width != 0.0) {
            xRatio = rect.size.width / inRect.size.width;
        }
        
        var yRatio:CGFloat = 1.0;
        if(inRect.size.height != 0.0) {
            yRatio = rect.size.height / inRect.size.height;
        }
        
        var aspectRatio:CGFloat = 1.0;
        if(aspectRatio != 0.0) {
            aspectRatio = rect.size.width / rect.size.height;
        }
        
        //fit sizes
        if (xRatio <= yRatio) {
            result.size.width = inRect.size.width;
            result.size.height = result.size.width / aspectRatio;
        }
        else {
            result.size.height = inRect.size.height;
            result.size.width = result.size.height * aspectRatio;
        }
        
        //center rect
        result = self.centerRect(result, inRect:inRect);
        
        return result;
    }
    
    class func centerRect(_ rect:CGRect, inRect:CGRect) -> CGRect {
        var result = rect;
        result.origin.x = inRect.origin.x + (inRect.size.width - result.size.width)*0.5;
        result.origin.y = inRect.origin.y + (inRect.size.height - result.size.height)*0.5;
        return result;
    }
    
    class func scaleRect(_ rect:CGRect, factor:CGFloat) -> CGRect {
        var r: CGRect = CGRect.zero;
        r.origin.x = rect.origin.x * factor;
        r.origin.y = rect.origin.y * factor;
        r.size.width = rect.size.width * factor;
        r.size.height = rect.size.height * factor;
        return r;
    }
}
