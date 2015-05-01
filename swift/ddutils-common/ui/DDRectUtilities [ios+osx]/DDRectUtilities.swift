#if os(iOS)
    import UIKit
    #else
    import Foundation
    import CoreGraphics
#endif

class DDRectUtilities {

    #if os(iOS)
    class func adjustRectForViewContent(unscaledRect:CGRect, view:UIView) -> CGRect {
        let bounds = view.bounds;
        var rect = unscaledRect;
        switch (view.contentMode) {
        case UIViewContentMode.ScaleToFill:
            return bounds;
            
        case UIViewContentMode.ScaleAspectFit:
            return self.fitRect(rect, inRect:bounds);
            
        case UIViewContentMode.ScaleAspectFill:
            return self.fillRect(rect, inRect:bounds);
            
        case UIViewContentMode.Redraw:
            return rect;
            
        case UIViewContentMode.Center:
            return self.centerRect(rect, inRect:bounds);
            
        case UIViewContentMode.Top:
            rect.origin.y = bounds.origin.y;
            break;
            
        case UIViewContentMode.Bottom:
            rect.origin.y = bounds.origin.y + bounds.size.height - rect.size.height;
            return rect;
            
        case UIViewContentMode.Left:
            rect.origin.x = bounds.origin.x;
            return rect;
            
        case UIViewContentMode.Right:
            rect.origin.x = bounds.origin.x + bounds.size.width - rect.size.width;
            return rect;
            
        case UIViewContentMode.TopLeft:
            rect.origin.x = bounds.origin.x;
            rect.origin.y = bounds.origin.y;
            return rect;
            
        case UIViewContentMode.TopRight:
            rect.origin.x = bounds.origin.x + bounds.size.width - rect.size.width;
            rect.origin.y = bounds.origin.y;
            return rect;
            
        case UIViewContentMode.BottomLeft:
            rect.origin.x = bounds.origin.x;
            rect.origin.y = bounds.origin.y + bounds.size.height - rect.size.height;
            return rect;
            
        case UIViewContentMode.BottomRight:
            rect.origin.x = bounds.origin.x + bounds.size.width - rect.size.width;
            rect.origin.y = bounds.origin.y + bounds.size.height - rect.size.height;
            return rect;
            
        default:
            println("Unknown content mode: \(view.contentMode)");
        }
        return rect;
    }
    #endif
    
    //MARK: -
    
    class func fitRect(rect:CGRect, inRect:CGRect) -> CGRect {
        var result = CGRectZero;
        
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
    
    class func fillRect(rect:CGRect, inRect:CGRect) -> CGRect {
        var result = CGRectZero;
        
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
    
    class func centerRect(rect:CGRect, inRect:CGRect) -> CGRect {
        var result = rect;
        result.origin.x = inRect.origin.x + (inRect.size.width - result.size.width)*0.5;
        result.origin.y = inRect.origin.y + (inRect.size.height - result.size.height)*0.5;
        return result;
    }
    
    class func scaleRect(rect:CGRect, factor:CGFloat) -> CGRect {
        var r: CGRect = CGRectZero;
        r.origin.x = rect.origin.x * factor;
        r.origin.y = rect.origin.y * factor;
        r.size.width = rect.size.width * factor;
        r.size.height = rect.size.height * factor;
        return r;
    }
}