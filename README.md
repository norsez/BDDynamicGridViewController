#BDDynamicGridViewController - Data-aware view-controller that displays a UIView list in an automatically laid out grid.

Data-aware view controller that displays a UIView list (typically, UIImageView list) in a row-dominated grid layout. This class automatically lay out the UIViews with help from a delegate class (which is supplier by you.)

##Sample Screenshot (better viewed in the iOS demo project.)

These are sample layout of the same UIView list automatically laid out by this class.

[![](https://github.com/norsez/BDDynamicGridViewController/raw/master/BDDynamicGridViewDemo/screencap1.png)](https://github.com/norsez/BDDynamicGridViewController/raw/master/BDDynamicGridViewDemo/screencap1.png) [![](https://github.com/norsez/BDDynamicGridViewController/raw/master/BDDynamicGridViewDemo/screencap2.png)](https://github.com/norsez/BDDynamicGridViewController/raw/master/BDDynamicGridViewDemo/screencap2.png) [![](https://github.com/norsez/BDDynamicGridViewController/raw/master/BDDynamicGridViewDemo/screencap3.png)](https://github.com/norsez/BDDynamicGridViewController/raw/master/BDDynamicGridViewDemo/screencap3.png)

##How to use
###Installation 
- Copy `.h/.m` files from the `Classes` folder into your code base
- Or you can use Cocoapods, add the following line into your Podfile

    dependency 'BDDynamicGridViewController'

###Implementation
####`BDDynamicGridViewController`
This is the main view controller initialized using `init`. Subclassing is recommended. Once initialized, set a delegate class to it. It receives delegate of type `BDDynamicGridViewDelegate`. See next. 

One you have your delegate set up. Call `reloadData` to see the layout. Each call to `reloadData` creates a new layout.

Once the view is loaded. User can tap on each view. There are two gestures supported, namely, long press and double tap. These are configurable using blocks through the following properties: `onLongPress` and `onDoubleTap`. Each block call is supplied with the gesture-recognized UIView and its index corresponding to the index in the `-viewAtIndex` method.


####`BDDynamicGridViewDelegate`
This is the delegate protocol needed by `BDDynamicGridViewController`. All methods are required to implement.

- `-numberOfViews` returns the total count of UIViews to display.
- `-viewAtIndex:` returns a UIView at an index specified.
- `-maximumViewsPerCell` returns the maximum number of UIViews per row. `BDDynamicGridViewController` uses this method to determine how many UIViews it can fill in each row at the most.
- `-rowHeightForRowInfo` `BDDynamicGridViewController` calls this method in order to set each row's height. The supplied `rowInfo` contains the information useful for the delegate to decide on the row height, such as, the number of UIViews contained in this row, etc.

That's it!

##Requirements
- Requires ARC


##How to use
- Include h/.m files in Classes folder to your source code
- Check out the iPhone demo. Read the comments. Send me questions, if any.


##License
BDDynamicGridViewController is licensed under BSD. More info in LICENSE file.