//
//  DDAnimatingView.m
//  animatingView
//
//  Created by Dominik Pich on 28/04/15.
//  Copyright (c) 2015 Dominik Pich. All rights reserved.
//
import UIKit

let DDSlidingDirectionTop = 2;
let DDSlidingDirectionBottom = 4;
let DDSlidingDirectionLeft = 1;
let DDSlidingDirectionRight = 3;

@IBDesignable
class DDSlidingImageView : UIView {
    var _sourceValue:CGFloat = 0;
    var _targetValue:CGFloat = 0;
    var _startDate:Date?;
    var _endDate:Date?;
    var _displayLink:CADisplayLink?;

    var _currentValue:CGFloat = 0; //shown
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //mark: public properties
    
    var image:UIImage? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var sliderColor:UIColor = UIColor.red {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var sliderValue:CGFloat=0 {
        didSet {
            if(_currentValue != sliderValue) {
                self.moveSlider();
            }
        }
    }

    var sliderDuration:CGFloat=0 {
        didSet {
            if(_currentValue != self.sliderValue) {
                self.moveSlider();
            }
        }
    }

    var sliderDirection:Int=0 {
        didSet {
            self.setNeedsDisplay();
        }
    }

    //MARK: - animating

    func moveSlider() {
        if(self.sliderDuration == 0) {
            _currentValue = self.sliderValue;
            self.setNeedsDisplay();
        }
        else {
            self.reflectSliderValueAnimated();
        }
    }

    func reflectSliderValueAnimated() {
        _sourceValue = _currentValue; // set start to current color
        _targetValue = self.sliderValue; // destination color
        _startDate = Date(); // begins currently, you could add some delay if you wish
        
        let ti = Double(self.sliderDuration) as TimeInterval
        _endDate = _startDate?.addingTimeInterval(ti); // will define animation duration
        
        if _displayLink != nil {
            _displayLink!.invalidate(); // if one already exists
        }
        
        _displayLink = CADisplayLink(target: self, selector: #selector(DDSlidingImageView.onFrame)); // create the display link
        _displayLink!.add(to: RunLoop.main, forMode: RunLoopMode.commonModes);
    }
    
    func interpolatedValue(_ sourceValue:CGFloat, targetValue:CGFloat, forScale:CGFloat) -> CGFloat {
        // this will interpolate between two values
        let between = targetValue - sourceValue;
        return sourceValue + between * forScale;
    }

    func onFrame() {
        // scale is valid between 0 and 1
        var scale = Date().timeIntervalSince(_startDate!) / _endDate!.timeIntervalSince(_startDate!);
        if(scale < 0) {
            // this can happen if delay is used
            scale = 0;
        }
        else if(scale > 1)
        {
            // end animation
            scale = 1;
            if _displayLink != nil {
                _displayLink!.invalidate();
                _displayLink = nil;
            }
        }
        
        //draw the current value
        _currentValue = self.interpolatedValue(_sourceValue, targetValue: _targetValue, forScale: CGFloat(scale));
        self.setNeedsDisplay();
    }

    //MARK: - drawing

    override func draw(_ rect: CGRect) {
        var imageRect:CGRect = CGRect.zero;
        imageRect.size = self.image!.size;
        imageRect = DDRectUtilities.adjustRectForViewContent(imageRect, view: self);
        self.image!.draw(in: imageRect);
        
        //figure out the bounds based frame for the _currentValue
        var valueFrame = imageRect;
        if(self.sliderDirection % 2 == 0) {
            valueFrame.size.height *= _currentValue;
            
            if(self.sliderDirection == DDSlidingDirectionBottom) {
                valueFrame.origin.y = imageRect.origin.y + imageRect.size.height - valueFrame.size.height;
            }
        }
        else {
            valueFrame.size.width *= _currentValue;
            
            if(self.sliderDirection == DDSlidingDirectionRight) {
                valueFrame.origin.x = imageRect.origin.x + imageRect.size.width - valueFrame.size.width;
            }
        }
        
        self.sliderColor.setFill();
        UIRectFillUsingBlendMode(valueFrame, CGBlendMode.colorBurn);
    }
}
