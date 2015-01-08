# MBSimpleLoadingIndicator

![demo](http://i.imgur.com/iNn66PI.gif)

Code:
``` objc
  //Create the loader
  _loadview = [[MBLoadingIndicator alloc] init];
    
  //Start the loader
  [self.loadview start];
    
  //Add the loader to our view
  [self.view addSubview:self.loadview];
```

![animprops](http://i.imgur.com/LVvInDR.png)

## Usage

###Change the percentage
``` objc
//Change the percentage
[_loadview incrementPercentageBy:17];

//Fill up and start ending animation
[_loadview finish];
```

###Animated properties of the loader
``` objc
//Change loader colors
[_loadview setLoadedColor:[UIColor darkGrayColor]];
[_loadview setLoaderBackgroundColor:[UIColor whiteColor]];

//Change loader sizes
[_loadview setWidth:15];
[_loadview setOuterLoaderBuffer:0];

//Move the loader
[_loadview offsetCenterXBy:50.0f];
[_loadview offsetCenterYBy:50.0f];
```

###Setup properties of loader
``` objc
//Choose full circle, half circle, or line
[_loadview setLoaderStyle:MBLoaderFullCircle];

//Preset sizes (tiny, small, medium, large)
[_loadview setLoaderSize:MBLoaderLarge];

//If you need greater control over the size
[_loadview setRadius:30];

//Set where the line originates from (full circle style only)
[_loadview setStartPosition:MBLoaderRight];

//Set animation speed
[_loadview setAnimationSpeed:MBLoaderSpeedFast];
```

###Accessing loader information
``` objc
//Get the percentage amount that is full (after current animation)
NSInteger amt = [_loadview getPercentage];
```

##Other useful things
``` objc
//Hide the loader (useful if error in main app occured)
[_loadview dismiss];
```

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

MBSimpleLoadingIndicator is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "MBSimpleLoadingIndicator"

##Troubleshooting
*Open an issue with GitHub's issue reporting system
*Send me an email at mattbrenman@gmail.com
*Send me a tweet at @mattbrenman with #MBLoaderIndicator

## Author

mbrenman, mattbrenman@gmail.com

## License

MBSimpleLoadingIndicator is available under the MIT license. See the LICENSE file for more info.

