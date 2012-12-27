#About
this is a VERY loose collection of individual classes and/or components for OSX/IOS that I find myself reusing serveral times and so thought it that it might be good to make them available.

most of the classes are not tested and have no documentation. They also arent meant or even guaranteed to be feature complete.
<b>they were/are all used in one or the other published app though.</b>

model:
<ul>
<li><b>BonjourServicesBrowser [ios+osx]</b> - asynchronously finds services using NSNetServiceBrowser

<li><b>DBPrefsWindowController [osx]</b> - a window controller that is tailored for doing preferences windows. (has a tabbar, crossfades. Meant to be subclassed. Based on class by Dave Batton)

<li><b>DDASLQuery [ios+osx] + demo</b> - wraps the C apis for querying ASL (default log on ios4+ or 10.6+)

<li><b>DDChecksum [ios+osx] + demo</b> - wraps the C api for building checksums (from apple's CommonCrypto library)

<li><b>DDEmbeddedDataReader [osx] + demo</b> - Based on code from BVPlistExtractor by Bavarious, this class allows easy reading of embedded (linked in) data from any executable. (e.g. a CLI Tool's plist included using the linker flag `-sectcreate __TEXT __info_plist TestInfo.plist`)

<li><b>DDMicBlowDetector [ios] + demo</b> - one class that worries about getting microphone input and making 'sure' that the sound is a blowing/hissing sound… not some random music. (the confidence value for this can be set, as well as min/max durations)
The basic algorithm is based on a tutorial from Mobile Orchad by Dan Grigsby.

<li><b>DDRecentItemsManager [ios+osx] + demo</b> - simple wrapper that stores a list of items (NSDictionaries). The array is trimmed to a user-definable maximum (on osx it uses NSDocumentController, on ios it is set to 10 by default). The list is persisted as a plist in the ApplicationSupport directory. 

<li><b>DDTask [osx] + demo</b> - 'Replacement' for NSTask that can be run multiple times in any operation / any thread. It tries to get a successful result N times and returns the result of stdout or nil.

<li><b>DDXcodeProject [osx] + demo</b> - A class that wraps a XCode project file. It extracts the basic project variables (name, orga, language, _resolved_ root dir) but it doesnt yet look up targets or files. It uses reflection for the parsing.. also nice. Ive first seen it in AQXMLParser :) 

<li><b>M42AbstractCoreDataStack [ios+osx]</b> - offers a simple core data wrapper (if one doesnt want to use the really good library MagicalRecord)

<li><b>M42RandomIndexPermutation M42CompatibleAlert [ios+osx] + demo</b> - Helper to build indexsets that are random but the indices remain unique and the sets reproducable.

<li><b>NSFileManager+Count [osx]</b> - (Cocoa wrapper for legacy but fast carbon way of counting files in a folder )

<li><b>NSString+advancedSplit [ios+osx] + demo</b> - A 'smarter' version of componentsBySplittingString. It never breaks inside of quotes and respects escaped strings.

<li><b>NSDictionary+PostData [ios+osx]</b> - Provides a method to get POST Data from a dictionary it supports NSStrings and NSData(!) [it creates multipart post]

<li><b>NSObject+DDDump [ios+osx] + demo</b> - provides a dictionary with reflected information about the class (superclass, protocols, ivars, properties, methods). The category also has a 'dump' method to assemble the data into a NSString that you can output.

<li><b>NSString+Entities [ios+osx]</b> - Escapes Entities so the NSString is valid for xml content

<li><b>NSString+ValidateEmail [ios+osx] + demo</b> - Check if a NSString object represents a valid email. Uses some regex.

<li><b>SKPaymentQueue+TransactionForProduct [ios+osx]</b> - Category to search in a PaymentQueue for (any / first successful[restored or not]) transaction for a given product identifier.

<li><b>NSWorkspace+runFileAtPath [osx]</b> - category that provides a method to run any file. It can be an Applescript (NSApplescript is used), a shell script or exectuable (NSTask is used),  a file wrapper or app (NSWorkspace is used) or a directory (is opened with the finder). Specified arguments are passed to the Apple Scripts, Shell scripts, to apps and to unix executables.

<li><b>NSArray+DDPerformAfterDelay [ios+osx]</b>-Category on NSArray to easily call makeObjectsPerformSelector after a delay

</ul>

ui:
<ul>
<li><b>DDAddressPicker [osx] +demo</b>- A Windowcontroller that offers a PeoplePicker allowing to pick persons from the addressbook. Adding some Features commonly needed

<li><b>M42ActionSheet [ios]]</b> - Drop In Replacement for UIActionSheet with support for custom colored buttons. (specifically we wanted a green one!)

<li><b>M42ClickableImagview & Label [ios]</b> - Subclasses that have action & target and react to touches

<li><b>M42CompatibleAlert [ios+osx]</b> - Class that wraps UIAlert and NSAlertView. Displaying the correct one depending on OS.

<li><b>M42LoadingScreenViewController [ios]</b> - Black screen, White 'Loading...', spinner, progressbar :) Looks a bit like the iOS Startup 
screen

<li><b>M42PieChartView [ios]</b> - A UIView that displays a 2D PieChart (for more graphing options, look into CorePlot)

<li><b>M42PinchableWebView [osx]</b> - Subclass of WebView which handles zooming in response to pinch gestures.

<li><b>M42TabBarController [ios]</b> - A tab bar that has a 'disabled' property and can draw with a 'black translucent' overlay to signal its status.

<li><b>M42WebViewController [ios]</b> - A view controller that manages a webview. It displays loading labels and offers a back button if appropriate

<li><b>M42WebviewTableViewCell [ios]</b> - Interesting cell that displays html content

<li><b>NSWindow+localize [osx]</b>-Category on NSWindow that localizes itself and all its subviews. (knows many defacto default selectors so it works with many views out-of-the-box) 

<li><b>NSWindow+Fade [osx]</b>-Category on NSWindow that adds fadeIn and fadeOut actions that work like animated order in order out

<li><b>NSView+findSubview [osx]</b>-Category on NSView that provides aa method to find a subview (by class and or tag) in its subview-tree.

<li><b>NSWorkspace+IconBadging [osx] + demo</b>-Category on NSWorkspace that allows setting icon <b>badges</b> on files/folder (like dropbox or torquoise SVN). (wraps carbon's IconServices API for that) 

<li><b>NSAttributedString+DDConvenience [ios+osx]</b>-Category on NSAttributedString to create it from printf like varargs (like stringWithFormat:)<br/>
On OSX there's also attributedStringWithImage.

</ul>

###ALL IS AVAIABLE under MIT