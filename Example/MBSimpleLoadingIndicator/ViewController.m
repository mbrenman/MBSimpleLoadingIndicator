//
//  ViewController.m
//  SimpleLoadingScreen
//
//  Created by Matt Brenman on 1/1/15.
//  Copyright (c) 2015 mbrenman. All rights reserved.
//

#import "ViewController.h"
#import "MBLoadingIndicator.h"

@interface ViewController ()

@property (nonatomic, strong) MBLoadingIndicator *loadview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Create the loader
    _loadview = [[MBLoadingIndicator alloc] init];
    
    //NOTE: Any extra loader can be done here, including sizing, colors, animation speed, etc
    //      Pre-start changes will not be animated.
    [_loadview setLoaderStyle:MBLoaderHalfCircle];
    [_loadview setLoaderSize:MBLoaderLarge];
    [_loadview setStartPosition:MBLoaderRight];
    [_loadview setAnimationSpeed:MBLoaderSpeedFast];
    [_loadview offsetCenterXBy:-12.5f];
    
    //Start the loader
    [self.loadview start];
    
    //Add the loader to our view
    [self.view addSubview:self.loadview];
}

- (void)viewDidAppear:(BOOL)animated
{
    int count = 0;
    
    //Increments delayed to show animations
    while (count++ < 7) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(count * 1.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (count % 2 != 0) {
                
                //Change loader colors
                [_loadview setLoadedColor:[UIColor darkGrayColor]];
                [_loadview setBufferColor:[UIColor whiteColor]];
                [_loadview setBackColor:[UIColor lightGrayColor]];
                
                //Change loader sizes
                [_loadview setWidth:15];
                [_loadview setOuterLoaderBuffer:0];
                
                //Move the loader
                [_loadview offsetCenterXBy:25.0f];
            } else {
                
                //Change loader colors
                [_loadview setLoadedColor:[UIColor orangeColor]];
                [_loadview setBufferColor:[UIColor blackColor]];
                [_loadview setBackColor:[UIColor magentaColor]];
                
                //Change loader sizes
                [_loadview setOuterLoaderBuffer:15];
                [_loadview setWidth:5];
                
                //Move the loader
                [_loadview offsetCenterXBy:-25.0f];
            }
            
            //Increment the loader
            [_loadview incrementPercentageBy:17];
            
        });
    
    }
}

@end
