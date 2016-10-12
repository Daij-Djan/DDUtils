//
//  DDMultiDateFormatter.m
//  DDMultiDateFormatter
//
//  Created by Dominik Pich on 1/2/16.
//  Copyright © 2016 Dominik Pich. All rights reserved.
//

import Foundation

open class DDMultiDateFormatter : Formatter {

    fileprivate var _formatters : [DateFormatter]!
    open var formatters : [DateFormatter] {
        get {
            if(_formatters == nil || _formatters.count == 0) {
                let enUSPOSIXLocale = Locale(identifier: "en_US_POSIX")
                
                let sRFC3339DateFormatterSubSeconds = DateFormatter()
                sRFC3339DateFormatterSubSeconds.locale = enUSPOSIXLocale
                sRFC3339DateFormatterSubSeconds.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSSSSXXXXX"
                sRFC3339DateFormatterSubSeconds.timeZone = TimeZone(secondsFromGMT: 0)
                
                let sRFC3339DateFormatter = DateFormatter()
                sRFC3339DateFormatter.locale = enUSPOSIXLocale
                sRFC3339DateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssXXXXX"
                sRFC3339DateFormatterSubSeconds.timeZone = TimeZone(secondsFromGMT: 0)
                
                _formatters = [sRFC3339DateFormatterSubSeconds, sRFC3339DateFormatter]
            }
            return _formatters
        }
        set {
            _formatters = newValue
        }
    }
    
    open func addNewFormatter(_ handler: (DateFormatter) -> Void) {
        var arr = self.formatters
        guard let first = arr.first else {
            fatalError("the formatters array is broken ")
        }
        
        let newF = first.copy() as! DateFormatter
        handler(newF)
        
        arr.append(newF)
        self.formatters = arr
    }

    open func removeFormatter(_ formatter: DateFormatter) {
        var arr = self.formatters
        if let index = arr.index(of: formatter) {
            arr.remove(at: index)
            self.formatters = arr
        }
    }

    open override var description: String {
        let array = self.formatters as NSArray
        let formats = array.value(forKey: "dateFormat") as! NSArray
        return formats.description
    }

    //MARK: -

    open override func string(for obj: Any?) -> String? {
        if let date = obj as? Date {
            return self.stringFromDate(date)
        }
        return nil
    }

    open override func attributedString(for obj: Any, withDefaultAttributes attrs: [String : Any]?) -> NSAttributedString? {
        if let str = self.string(for: obj) {
            if str.characters.count > 0 {
                return NSAttributedString(string: str, attributes: attrs)
            }
        }
        return nil
    }

    open override func editingString(for obj: Any) -> String? {
        return self.string(for: obj)
    }

    open override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        let date = self.dateFromString(string)
        if(date != nil && obj?.pointee != nil) {
            obj?.pointee = date as AnyObject?
        }
        else if(date == nil && error?.pointee != nil) {
            error?.pointee = "Cant parse string to NSDate"
        }
        return (date != nil);
    }

    open override func isPartialStringValid(_ partialString: String, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {    
        return true //anything goes ;)
    }
    
    //MARK: -

    //- (BOOL)getObjectValue:(out id __nullable * __nullable)obj forString:(NSString *)string range:(inout nullable NSRange *)rangep error:(out NSError **)error;

    open func stringFromDate(_ date: Date) -> String {
        var str = ""
        for formatter in formatters {
            str = formatter.string(from: date)
            if str.characters.count > 0 {
                break
            }
        }
        return str
    }
    
    open func dateFromString(_ string: String) -> Date? {
        var date : Date! = nil
        for formatter in formatters {
            date = formatter.date(from: string)
            if date != nil {
                break
            }
        }
        return date
    }
}
