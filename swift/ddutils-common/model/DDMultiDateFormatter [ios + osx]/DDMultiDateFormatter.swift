//
//  DDMultiDateFormatter.m
//  DDMultiDateFormatter
//
//  Created by Dominik Pich on 1/2/16.
//  Copyright © 2016 Dominik Pich. All rights reserved.
//

import Foundation

public class DDMultiDateFormatter : NSFormatter {

    private var _formatters : [NSDateFormatter]!
    public var formatters : [NSDateFormatter] {
        get {
            if(_formatters == nil || _formatters.count == 0) {
                let enUSPOSIXLocale = NSLocale(localeIdentifier: "en_US_POSIX")
                
                let sRFC3339DateFormatterSubSeconds = NSDateFormatter()
                sRFC3339DateFormatterSubSeconds.locale = enUSPOSIXLocale
                sRFC3339DateFormatterSubSeconds.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSSSSXXXXX"
                sRFC3339DateFormatterSubSeconds.timeZone = NSTimeZone(forSecondsFromGMT: 0)
                
                let sRFC3339DateFormatter = NSDateFormatter()
                sRFC3339DateFormatter.locale = enUSPOSIXLocale
                sRFC3339DateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssXXXXX"
                sRFC3339DateFormatterSubSeconds.timeZone = NSTimeZone(forSecondsFromGMT: 0)
                
                _formatters = [sRFC3339DateFormatterSubSeconds, sRFC3339DateFormatter]
            }
            return _formatters
        }
        set {
            _formatters = newValue
        }
    }
    
    public func addNewFormatter(handler: (NSDateFormatter) -> Void) {
        var arr = self.formatters
        guard let first = arr.first else {
            fatalError("the formatters array is broken ")
        }
        
        let newF = first.copy() as! NSDateFormatter
        handler(newF)
        
        arr.append(newF)
        self.formatters = arr
    }

    public func removeFormatter(formatter: NSDateFormatter) {
        var arr = self.formatters
        if let index = arr.indexOf(formatter) {
            arr.removeAtIndex(index)
            self.formatters = arr
        }
    }

    public override var description: String {
        let array = self.formatters as NSArray
        let formats = array.valueForKey("dateFormat") as! NSArray
        return formats.description
    }

    //MARK: -

    public override func stringForObjectValue(obj: AnyObject) -> String? {
        if let date = obj as? NSDate {
            return self.stringFromDate(date)
        }
        return nil
    }

    public override func attributedStringForObjectValue(obj: AnyObject, withDefaultAttributes attrs: [String : AnyObject]?) -> NSAttributedString? {
        if let str = self.stringForObjectValue(obj) {
            if str.characters.count > 0 {
                return NSAttributedString(string: str, attributes: attrs)
            }
        }
        return nil
    }

    public override func editingStringForObjectValue(obj: AnyObject) -> String? {
        return self.stringForObjectValue(obj)
    }


    public override func getObjectValue(obj: AutoreleasingUnsafeMutablePointer<AnyObject?>, forString string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>) -> Bool {
        let date = self.dateFromString(string)
        if(date != nil && obj.memory != nil) {
            obj.memory = date
        }
        else if(date == nil && error.memory != nil) {
            error.memory = "Cant parse string to NSDate"
        }
        return (date != nil);
    }

    public override func isPartialStringValid(partialStringPtr: AutoreleasingUnsafeMutablePointer<NSString?>, proposedSelectedRange proposedSelRangePtr: NSRangePointer, originalString origString: String, originalSelectedRange origSelRange: NSRange, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>) -> Bool {
        return true //anything goes ;)
    }
    
    //MARK: -

    //- (BOOL)getObjectValue:(out id __nullable * __nullable)obj forString:(NSString *)string range:(inout nullable NSRange *)rangep error:(out NSError **)error;

    public func stringFromDate(date: NSDate) -> String {
        var str = ""
        for formatter in formatters {
            str = formatter.stringFromDate(date)
            if str.characters.count > 0 {
                break
            }
        }
        return str
    }
    
    public func dateFromString(string: String) -> NSDate? {
        var date : NSDate! = nil
        for formatter in formatters {
            date = formatter.dateFromString(string)
            if date != nil {
                break
            }
        }
        return date
    }
}
