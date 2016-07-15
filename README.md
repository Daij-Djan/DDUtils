#About
this is a VERY loose collection of individual classes and/or components for OSX/IOS that I find myself reusing serveral times and so thought it that it might be good to make them available.

Most of the classes are arent meant or even guaranteed to be feature complete. Originally, they were developed for a very specific use case. They were/are all used in one or the other published app and then I thought I'd make them available to the general public.</b>

- new classes will be in swift (and sometimes in objC as well) but the 'old' objective-C classes are useful and still up to date too and I won't port all old code.

##Individual Classes
###Swift
######model-related:
<ul>
<li><b>EWSProfileImage [ios+osx] + Demo</b> - Class that will load & cache profile images from an exchange server</li>

<li><b>CLPlacemark+CNPostalAddress [ios + osx]</b> - An extension to get a CNPostalAddress from a placemark (cl or mk) that can be used to get a formatted address string in current IOS</li>

<li><b>CollectionType+Shuffle [ios+osx]</b> - A Category that adds the ability to shuffle (reproducably) any Collection that uses Integer-based Indices.
 
<li><b>NotificationObserver [ios+osx] + demo</b> - Makes observing a NSNotificationCenter easy, convenient and more swift like.</li>

<li><b>DDRequestQueue [ios+osx] + demo</b> - An easy class to queue up NSURLRequests that are processed when the app has a valid network connection. The requests are even persisted and the queue continues whenever it starts up again. It uses NSURLSession for the requests.</li>

<li><b>DDMultiDateFormatter [ios+osx] + demo </b> - A NSFormatter subclass that wraps multiple date formatters. This 'compound' date formatter by default adheres to RFC3339 but can be used to understand all kind of date formats.</li>

<li><b>NSURLConnection+ModifiedSince [ios+osx] + demo</b> - A category on NSURLConnection that provides an easy to use convenient method to Get & Cache Data (Using Modified-Since HTTP) [the demo is for IOS. the objC verion's demo is for OSX.</li>

<li><b>DDPermutation [ios+osx + demo]</b> - adds a Helper to build indexsets that are random but the indices remain unique and the sets reproducable. Wraps around arrays and can be used in a for in loop with arrays via the global method `permutate`</li>

<li><b>CLBeaconRegion+Dictionary [ios + osx]</b> - extension to add methods for convert from/to plist compatible dictionary.</li>

<li><b>NSUserDefaults+RunOnce [ios + osx]</b> - extension on user defaults to add a convenience method to run a specified closure only once per user (e.g. some legal info popup needs to be shown only once, or a tutorial or a certain system check).</li>

<li><b>String+FileName [ios + osx]</b> - extension to provide a getter for a valid (saveable) filename from a string (that may contain lots of unsaveable characters).</li>

</ul>

######ui-related:
<ul>
<li><b>UIViewController+Dummy [ios] + demo</b> - Helper that swizzles viewWillAppear and adds a navbar and buttons for all segues as needed! This is meant to be used during development only. At the beginning of development work you can 'test' out your storyboard flow.(segues need to have ids!)

<li><b>DDContentZoomSegue [ios + demo]</b> A custom segue that can be pushed / present modally using an 'expand/scale to reveal' animation. It takes into account the sender's placement for the best effect
'
<li><b>DDRectUtilities [ios+osx]</b> - Utility class with useful scaling/placement methods for CGRects

<li><b>NSView+Enable [osx]</b> - Category for NSView to quickly enable/disable it and all its subviews.

<li><b>DDSlidingImageView [ios + demo]</b> - View class that shows a UIImage (same as an imageView) but also supports 'covering it' by animating color to cover non-transparent areas of the image using a color. So it can do an animated 'colorize' of the image shown. I use it for FILLING effects. It uses CADisplayLink and also shows hhow to make a view IBDesignable. A Demo showing a configured view is included and the demo app shows the intrinsic animation</li>

<li><b>NSWindow+Fade [osx]</b> - Category for NSWindow that provides helpers to fade in/out a window when ordering it in/out

<li><b>NSImage+PNG [osx]</b> - a Category on NSImage to get NSData in PNG Format for saving it to file. This simplifies the 'weirdness' of NSImageRepresentations away ;)
</ul>

###ObjC
######model-related:
<ul>
<li><b>DDRequestQueue [ios+osx]</b> - An easy class to queue up NSURLRequests that are processed when the app has a valid network connection. The requests are even persisted and the queue continues whenever it starts up again. It uses NSURLSession for the requests.</li>

<li><b>DDMultiDateFormatter [ios+osx] + demo </b> - A NSFormatter subclass that wraps multiple date formatters. This 'compound' date formatter by default adheres to RFC3339 but can be used to understand all kind of date formats.</li>

<li><b>NSURLConnection+ModifiedSince [ios+osx] + demo</b> - A category on NSURLConnection that provides an easy to use convenient method to Get & Cache Data (Using Modified-Since HTTP) [the demo is for OSX. the swift verion's demo is for ios.</li>

<li><b>DDUnits [ios+osx] + demo</b> - A class to quickly convert between formatted strings and numbers for units.</li>

<li><b>NSFileManager+DataProtection [ios]</b> - A category  to quickly add data protection to a file</li>

<li><b>NSFileManager+SkipBackupAttributeToItemAtPath [ios]</b> - A category to exclude a file from an iTunes backup. (With apples storage guidelines, this is often important)

<li><b>DDSocialMessenger [ios+osx]</b> - provides easy-to-use methods to post to twitter or facebook or both! It encapsulates all dealings with accounts and social framework

<li><b>BonjourServicesBrowser [ios+osx]</b> - asynchronously finds services using NSNetServiceBrowser

<li><b>DDPowerMonitor [osx]</b> - easy monitor power mode (battery / ac / charging) and system sleep/wake

<li><b>DBPrefsWindowController [osx]</b> - a window controller that is tailored for doing preferences windows. (has a tabbar, crossfades. Meant to be subclassed. Based on class by Dave Batton)

<li><b>DDASLQuery [ios+osx] + demo</b> - wraps the C apis for querying ASL (default log on ios4+ or 10.6+)

<li><b>DDChecksum [ios+osx] + demo</b> - wraps the C api for building checksums (from apple's CommonCrypto library)

<li><b>DDEmbeddedDataReader [ios+osx] + demos</b> - Based on code from BVPlistExtractor by Bavarious, this class allows easy reading of embedded (linked in) data from any executable. (e.g. a CLI Tool's plist included using the linker flag `-sectcreate __TEXT __info_plist TestInfo.plist`)

<li><b>DDMicBlowDetector [ios] + demo</b> - one class that worries about getting microphone input and making 'sure' that the sound is a blowing/hissing sound… not some random music. (the confidence value for this can be set, as well as min/max durations)
The basic algorithm is based on a tutorial from Mobile Orchad by Dan Grigsby.

<li><b>DDFilterableArray [ios+osx] + demo</b> - basic Subclasses of NSArray and NSMutableArray AND a category on NSArray to make a Array class that you can easily filter by passing a prediate format string or a predicate inside of the brackets. (This is great for parsers, see xsd2cocoa for a real life usage)

<li><b>NSObject+TransparentKVC [ios+osx] + demo</b> - use @protocols fot typesafe KVC. E.g. for Accessing parsed JSON (nested NSDictionaries) [clean, consisce, effective, self documenting, see the Demo for a better explanation of this concept]

<li><b>DDRecentItemsManager [ios+osx] + demo</b> - simple wrapper that stores a list of items (NSDictionaries). The array is trimmed to a user-definable maximum (on osx it uses NSDocumentController, on ios it is set to 10 by default). The list is persisted as a plist in the ApplicationSupport directory. 

<li><b>DDTask [osx] + demo</b> - 'Replacement' for NSTask that can be run multiple times in any operation / any thread. It tries to get a successful result N times and returns the result of stdout or nil.

<li><b>DDRunTask [osx]</b> - 'Easy convenience' function for running a NSTask in a single line. Run a command just like you'd enter it on the console - quick'n'dirty ;)

<li><b>DDXcodeProject [osx] + demo</b> - A class that wraps a XCode project file. It extracts the basic project variables (name, orga, language, _resolved_ root dir) but it doesnt yet look up targets or files. It uses reflection for the parsing.. also nice. Ive first seen it in AQXMLParser :) 

<li><b>M42AbstractCoreDataStack [ios+osx]</b> - offers a simple core data wrapper (if one doesnt want to use the really good library MagicalRecord)

<li><b>M42RandomIndexPermutation [ios+osx] + demo</b> - Helper to build indexsets that are random but the indices remain unique and the sets reproducable.

<li><b>NSFileManager+Count [osx]</b> - (Cocoa wrapper for legacy but fast carbon way of counting files in a folder )

<li><b>NSString+advancedSplit [ios+osx] + demo</b> - A 'smarter' version of componentsBySplittingString. It never breaks inside of quotes and respects escaped strings.

<li><b>NSDictionary+PostData [ios+osx]</b> - Provides a method to get POST Data from a dictionary it supports NSStrings and NSData(!) [it creates multipart post]

<li><b>NSObject+DDDump [ios+osx] + demo</b> - provides a dictionary with reflected information about the class (superclass, protocols, ivars, properties, methods). The category also has a 'dump' method to assemble the data into a NSString that you can output.

<li><b>NSString+ValidateEmail [ios+osx] + demo</b> - Check if a NSString object represents a valid email. Uses some regex.

<li><b>SKPaymentQueue+TransactionForProduct [ios+osx]</b> - Category to search in a PaymentQueue for (any / first successful[restored or not]) transaction for a given product identifier.

<li><b>NSWorkspace+runFileAtPath [osx]</b> - category that provides a method to run any file. It can be an Applescript (NSApplescript is used), a shell script or exectuable (NSTask is used),  a file wrapper or app (NSWorkspace is used) or a directory (is opened with the finder). Specified arguments are passed to the Apple Scripts, Shell scripts, to apps and to unix executables.

<li><b>NSArray+DDPerformAfterDelay [ios+osx]</b> - Category on NSArray to easily call makeObjectsPerformSelector after a delay

<li><b>NSManagedObjectContext+RefreshObjectRecursive [ios+osx]</b> - Category on the context to allow to refresh an object RECURSIVELY. The normal refreshObject isnt recursive.

<li><b>NSOperation+Duration [ios+osx] + demo</b> - Category that adds a duration property to ANY NSOperation. (The included test app shows this working with AFNetworking!)

<li><b>NSOperation+UserInfo [ios+osx] + demo</b> - Category that adds a userInfo dictionary property to ANY NSOperation. (The included test app shows this working with AFNetworking!)

<li><b>NSObject+MethodSwizzle [ios+osx] + demo</b> - I found myself doing a lot of swizzling recently, so I added this category. I especially like mikeash's neat trick of swizzling a method of ANY class with a C Function you provide!

<li><b>UIFont+RegisterURL [ios]</b> - This category enables you to load a UIFont from ANY url. The url can be local or remote. It can also point to local a folder (or a NSBundle) to load fonts from there :) Last but not least it provides a convenience method fontWithName:size:ifNeededLoadURL:

<li><b>DDOpenAtLoginController [osx]</b> - This class provides a single property. 'appStartsAtLogin' It adds/removes the current app from the login items list. That bool is bindable and and reflects the system preferences. 

<li><b>DDLMUService [osx]</b> - A wrapper for the undocumented IOKit LMUService: The 'kernel driver' for the ambient light sensor AND the LED Backlight of Macbooks (only tested under 10.9 on MBP 2011 but should work for any Macbook able to run 10.8+)

<li><b>DDUserNotificationCenterMonitor [osx]</b> - Component that monitors the global MTNLion notification center. (It uses SCEvents to monitor disk changes and FMDB to read the Notification Center's SQLite database.)

<li><b>DDLanguageConverter [ios+osx]</b>Class to convert between apple language codes to iso6392 language codes or iso3166a3 country codes.<br/> Also includes two categories for NSLocale to ease development.</li>

<li><b>DDXMLValidator [ios + osx] + demo</b> - Component that validates a given XML file (local or remote) against a Schema (which can be XSD, DTD or RNG.) (It uses libxml2 for the validation and is based on code by Todd Ditchendorfer.)

<li><b>DDAppStoreInfo [ios+osx] + demo</b> - Component that shows how to easily fetch information from the appstore via the Apple iTunes Lookup API

<li><b>NSObject+isValidPlist [ios+osx]</b> - Quick category on NSObject to see if it a plist type and if it is an array or dictionary if it only contains plist objects

</ul>

######ui-related:
<ul>
<li><b>UIViewController+Dummy [ios] + demo</b> - Helper that swizzles viewWillAppear and adds a navbar and buttons for all segues as needed! This is meant to be used during development only. At the beginning of development work you can 'test' out your storyboard flow.(segues need to have ids!)

<li><b>UIImage+AssertNamed [ios]</b> - Helper that swizzles imageNamed and assert the image can be found! This is meant to be used during development only

<li><b>DDImage+Masked [ios+osx]</b> - Category for both UIImage and NSImage that simplifies masking one image with another one. (It hides all the 'annoying ;)' CoreGraphics code)

<li><b>DDRectUtilities [ios+osx]</b> - Utility class with useful scaling/placement methods for CGRects

<li><b>DDAddressPicker [osx] +demo</b> - A Windowcontroller that offers a PeoplePicker allowing to pick persons from the addressbook. Adding some Features commonly needed

<li><b>M42ActionSheet [ios]</b> - Drop In Replacement for UIActionSheet with support for custom colored buttons. (specifically we wanted a green one!)

<li><b>M42ClickableImagview & Label [ios]</b> - Subclasses that have action & target and react to touches

<li><b>M42LoadingScreenViewController [ios]</b> - Black screen, White 'Loading...', spinner, progressbar :) Looks a bit like the iOS Startup 
screen

<li><b>M42PieChartView [ios]</b> - A UIView that displays a 2D PieChart (for more graphing options, look into CorePlot)

<li><b>M42PinchableWebView [osx]</b> - Subclass of WebView which handles zooming in response to pinch gestures.

<li><b>M42TabBarController [ios]</b> - A tab bar that has a 'disabled' property and can draw with a 'black translucent' overlay to signal its status.

<li><b>M42WebViewController [ios]</b> - A view controller that manages a webview. It displays loading labels and offers a back button if appropriate

<li><b>M42WebviewTableViewCell [ios + demo]</b> - Interesting cell that displays html content and tells the controller its required size. A Demo using a minimal tabeView is included.

<li><b>NSWindow+localize [osx]</b> - Category on NSWindow that localizes itself and all its subviews. (knows many defacto default selectors so it works with many views out-of-the-box) 

<li><b>NSWindow+Fade [osx]</b> - Category on NSWindow that adds fadeIn and fadeOut actions that work like animated order in order out

<li><b>NSView+findSubview [osx]</b> - Category on NSView that provides aa method to find a(or many) subview (by class and or tag) in its subview-tree.

<li><b>UIView+didAddSubview [ios]</b> - Category on UIView that swizzles in a delegate that gets always called after the view's own didAddSubview method. You no longer have to subclass a view because you need didAddSubview! (needs NSObject+MethodSwizzle!)

<li><b>UIView+findSubview [ios]</b> - Category on UIView that provides methods to find a(or many) subview (by class and or tag) in its subview-tree.

<li><b>UIView+Border [ios]</b> - Category on UIView that provides a simple wrapper around CALayer allowing to easily add a border around a view.

<li><b>NSWorkspace+IconBadging [osx] + demo</b> - Category on NSWorkspace that allows setting icon <b>badges</b> on files/folder (like dropbox or torquoise SVN). (wraps carbon's IconServices API for that) 

<li><b>NSAttributedString+DDConvenience [ios+osx]</b> - Category on NSAttributedString to create it from printf like varargs (like stringWithFormat:)<br/>
On OSX there's also attributedStringWithImage.

<li><b>UIAlertView+UserInfo [ios]</b> - Category on UIAlertView that adds a userInfo NSDictionary property to the alert that you can set and get (like it works for NSTimer)

<li><b>UIImage+DDBadge [ios]</b> - Category on UIImage that returns a badged copy of an image. The look of the badge is customizable to a certain degree

<li><b>UIImage+DefaultImage</b> - Category on UIImage to easily get the Current App's Default image (the correct version for the Current Device)

<li><b>DDTextField [ios + demo]</b> - Interesting compound class that provides a common interface for single-line UITextFields and multi-line UITextViews. A Demo showing some differently configured textfields is included. (and the class shows how IBDesignable and IBInspectable works)

<li><b>DDSlidingImageView [ios + demo]</b> - View class that shows a UIImage (same as an imageView) but also supports 'covering it' by animating color to cover non-transparent areas of the image using a color. So it can do an animated 'colorize' of the image shown. I use it for FILLING effects. It uses CADisplayLink and also shows hhow to make a view IBDesignable. A Demo showing a configured view is included and the demo app shows the intrinsic animation
</ul>

<br/>
<br/>
###ALL IS AVAIABLE under MIT
