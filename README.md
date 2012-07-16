#About
this is a VERY loose collection of individual classes and/or components for OSX/IOS that I find myself reusing serveral times and so thought it that it might be good to make them available.

most of the classes are not tested and have no documentation. They also arent meant or even guaranteed to be feature complete.
<b>they were/are all used in one or the other published app though.</b>

model:
<ul>
<li><b>BonjourServicesBrowser [ios+osx]</b> - asynchronously finds services using NSNetSerrviceBrowser

<li><b>DDASLQuery [ios+osx] + demo</b> - wraps the C apis for querying ASL (default log on ios4+ or 10.6+)

<li><b>DDChecksum [ios+osx] + demo</b> - wraps the C api for building checksums (from apple's CommonCrypto library)

<li><b>DDEmbeddedDataReader [osx] + demo</b> - Based on code from BVPlistExtractor by Bavarious, this class allows easy reading of embedded (linked in) data from any executable. (e.g. a CLI Tool's plist included using the linker flag `-sectcreate __TEXT __info_plist TestInfo.plist`)

<li><b>DDTask [osx] + demo</b> - 'Replacement' for NSTask that can be run multiple times in any operation / any thread. It tries to get a successful result N times and returns the result of stdout or nil.

<li><b>M42AbstractCoreDataStack [ios+osx]</b> - offers a simple core data wrapper (if one doesnt want to use the really good library MagicalRecord)

<li><b>M42RandomIndexPermutation M42CompatibleAlert [ios+osx] + demo</b> - Helper to build indexsets that are random but the indices remain unique and the sets reproducable.

<li><b>NSFileManager+Count [osx]</b> - (Cocoa wrapper for legacy but fast carbon way of counting files in a folder )

<li><b>NSString+advancedSplit[ios+osx]</b> - A 'smarter' version of componentsBySplittingString. It never breaks inside of quotes.

<li><b>NSString+Entities [ios+osx]</b> - Escapes Entities so the NSString is valid for xml content

<li><b>NSString+ValidateEmail [ios+osx] + demo</b> - Check if a NSString object represents a valid email. Uses some regex.

<li><b>SKPaymentQueue+TransactionForProduct [ios]</b> - Category to search in a PaymentQueue for (any / first successful[restored or not]) transaction for a given product identifier.
</ul>

ui:
<ul>
<li><b>M42ClickableImagview & Label [ios]</b> - Subclasses that have action & target and react to touches

<li><b>M42CompatibleAlert [ios+osx]</b> - Class that wraps UIAlert and NSAlertView. Displaying the correct one depending on OS.

<li><b>M42LoadingScreenViewController [ios]</b> - Black screen, White 'Loading...', spinner, progressbar :) Looks a bit like the iOS Startup 
screen

<li><b>M42PieChartView [ios]</b> - A UIView that displays a 2D PieChart (for more graphing options, look into CorePlot)

<li><b>M42PinchableWebView [osx]</b> - Subclass of WebView which handles zooming in response to pinch gestures.

<li><b>M42TabBarController [ios]</b> - A tab bar that has a 'disabled' property and can draw with a 'black translucent' overlay to signal its status.

<li><b>M42WebViewController [ios]</b> - A view controller that manages a webview. It displays loading labels and offers a back button if appropriate

<li><b>M42WebviewTableViewCell [ios]</b> - Interesting cell that displays html content

<li><b>NSWindow+localize [osx]</b>-Category on NSWindow that localizes itself and all its subviews. 
</ul>

#ALL IS AVAIABLE under MIT