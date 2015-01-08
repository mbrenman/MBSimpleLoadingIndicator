//
//  LoadingView.h
//  SimpleLoadingScreen
//
//  Created by Matt Brenman on 1/1/15.
//  Copyright (c) 2015 mbrenman. All rights reserved.
//

#ifndef MBLoadingIndicator_h
#define MBLoadingIndicator_h

@import UIKit;

@class MBLoadingIndicator;

typedef NSInteger MBLoaderSpeed;
typedef NSInteger MBLoaderStartPosition;
typedef NSInteger MBLoaderStyle;
typedef NSInteger MBLoaderSize;

enum LoaderStyles {MBLoaderFullCircle, MBLoaderHalfCircle, MBLoaderLine};
enum LoaderStartPositions {MBLoaderLeft, MBLoaderRight, MBLoaderTop, MBLoaderBottom};
enum LoaderAnimationSpeeds {MBLoaderSpeedSlow, MBLoaderSpeedMiddle, MBLoaderSpeedFast};
enum LoaderSizes {MBLoaderTiny, MBLoaderSmall, MBLoaderMedium, MBLoaderLarge};

@interface MBLoadingIndicator : UIView

//Pre-Start Setup Methods
- (void)setLoaderStyle:(MBLoaderStyle)type;
- (void)setStartPosition:(MBLoaderStartPosition)startPos;
- (void)setLoaderSize:(MBLoaderSize)size;
- (void)setRadius:(NSInteger)radius;

//Starting and Ending Animation
- (void)start;
- (void)finish;
- (void)dismiss;

//Anytime Methods (animated after start)
// --Colors
- (void)setBackColor:(UIColor *)backColor;
- (void)setLoaderBackgroundColor:(UIColor *)circleColor;
- (void)setLoadedColor:(UIColor *)loadedColor;
// --Circle Properties
- (void)setWidth:(NSInteger)width;
- (void)setOuterLoaderBuffer:(NSInteger)buff;
- (void)incrementPercentageBy:(NSInteger)amount;
- (void)offsetCenterXBy:(CGFloat)y_off;
- (void)offsetCenterYBy:(CGFloat)y_off;
// --Animation Properties
- (void)setAnimationSpeed:(MBLoaderSpeed)speed;

//Accessing Data
- (NSInteger)getPercentage;

@end

#endif
