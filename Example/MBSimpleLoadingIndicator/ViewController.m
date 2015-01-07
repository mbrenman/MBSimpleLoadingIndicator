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
                [_loadview setLoadedColor:[UIColor colorWithRed:0.61 green:0.85 blue:0.94 alpha:1]];
                [_loadview setLoaderBackgroundColor:[UIColor colorWithRed:0.55 green:0.54 blue:0.53 alpha:1]];
                
                //Change loader sizes
                [_loadview setWidth:15];
                [_loadview setOuterLoaderBuffer:0];
            } else {
                
                //Change loader colors
                [_loadview setLoadedColor:[UIColor lightGrayColor]];
                [_loadview setLoaderBackgroundColor:[UIColor darkGrayColor]];
                
                //Change loader sizes
                [_loadview setOuterLoaderBuffer:15];
                [_loadview setWidth:5];
            }
            
            //Increment the loader
            [_loadview incrementPercentageBy:17];
        });
    
    }
}

@end
