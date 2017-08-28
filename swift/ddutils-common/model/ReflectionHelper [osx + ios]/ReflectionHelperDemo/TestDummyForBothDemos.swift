
import Foundation

class TestDummy : NSObject{
    class Inner {
        var test = "String"
    }
    
    enum TestMe : Int {
        case X = 1
        case Y = 2
    }

    /** Property that sets the NSLocale used by formatters of this type. It defaults to enUSPOSIX */
    ///not using new Locale!
    var locale = NSLocale(localeIdentifier: "en_US_POSIX")
    
    var addressLine1: String? = "adasdLine1"
    
    var addressLine2: String? = "tempLine2"
    
    var addressMatch: Bool? = true
        
    var inner = Inner()
    
    var test : TestMe? = TestMe.X

    var decimalTest : Double = {
        let numFormatter = NumberFormatter()
        numFormatter.numberStyle = NumberFormatter.Style.decimal
        numFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let str = UnsafePointer<CChar>("12.34")
        let value = "12.34"//String(validatingUTF8:UnsafeRawPointer(str).assumingMemoryBound(to: Int8.self))!
        let trimmed = value.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines)
        let d = numFormatter.number(from:trimmed)!.doubleValue
        let n = NSNumber(value: d)
        
        return d
    }()
}

