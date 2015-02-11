/**
@file      CGRectHelpers.m
@author    Dominik Pich
@date      2013-03-26
*/
#import "CGRectHelpers.h"

CGRect CGRectWithUIEdgeInsets(CGRect rect, UIEdgeInsets insets) {
    rect.origin.x += insets.left;
    rect.origin.y += insets.top;
    rect.size.width -= (insets.left + insets.right);
    rect.size.height -= (insets.top + insets.bottom);
    return rect;
}

CGRect RoundedCGRect(CGRect rect) {
    rect.size.width = roundf(rect.size.width);
    rect.size.height = roundf(rect.size.height);
    rect.origin.x = roundf(rect.origin.x);
    rect.origin.y = roundf(rect.origin.y);
    return rect;
}
