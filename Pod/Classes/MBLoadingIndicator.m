//
//  LoadingView.m
//  SimpleLoadingScreen
//
//  Created by Matt Brenman on 1/1/15.
//  Copyright (c) 2015 mbrenman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBLoadingIndicator.h"

const CGFloat pi = 3.14159265359;

@interface MBLoadingIndicator ()

//Drawing properties
@property (nonatomic) CGRect frame;
@property (nonatomic) CGFloat alpha;
@property (nonatomic, strong) UIColor *backColor;
@property (nonatomic, strong) UIColor *bufferColor;
@property (nonatomic, strong) UIColor *loadedColor;

//Animation Properties
@property (nonatomic) CGFloat duration;
// --ShapeLayers
@property (nonatomic, strong) CAShapeLayer *backgroundCircleLayer;
@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic, strong) CAShapeLayer *backgroundLayer;
// --Tracking Animations
@property (nonatomic) BOOL percentAnimating;
@property (nonatomic) BOOL loaderStarted;
@property (nonatomic) BOOL endingAnimStarted;
@property (nonatomic) BOOL widthAnimating;
@property (nonatomic) BOOL loadedColorAnimating;
@property (nonatomic) BOOL bufferColorAnimating;
@property (nonatomic) BOOL backgroundColorAnimating;
// --Animation Queues
@property (nonatomic) NSMutableArray *widthQueue;
@property (nonatomic) NSMutableArray *loadedColorQueue;
@property (nonatomic) NSMutableArray *bufferColorQueue;
@property (nonatomic) NSMutableArray *backgroundColorQueue;

//Loader Path properties
@property (nonatomic) MBLoaderStyle style;
@property (nonatomic) NSInteger percentage;
@property (nonatomic) NSInteger prevPercentage;
@property (nonatomic, strong) UIBezierPath *bufferPath;
@property (nonatomic, strong) UIBezierPath *loaderPath;
@property (nonatomic) CGFloat arcLength;
@property (nonatomic) CGFloat offset;
// --Placement and Sizing
@property (nonatomic) NSInteger radius;
@property (nonatomic) NSInteger width;
@property (nonatomic) NSInteger buff;
@property (nonatomic) CGFloat x_center_offset;
@property (nonatomic) CGFloat y_center_offset;

//Animation label properties
@property (nonatomic, strong) NSString *animType;
@property (nonatomic, strong) NSString *percentAnim;

@end

@implementation MBLoadingIndicator

#pragma mark animation

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    NSString *anim = [theAnimation valueForKey:self.animType];
    if ([anim isEqualToString:self.percentAnim]) {
        self.percentAnimating = NO;
        if (self.endingAnimStarted) {
            [self dismiss];
        } else {
            [self loadAnimation];
            if (self.prevPercentage == 100) {
                //Start ending animation
                _endingAnimStarted = YES;
            }
        }
    }
}

- (void)finish
{
    //Will always fill up counter
    [self incrementPercentageBy:100];
}

- (void)dismiss
{
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:self.duration]
                     forKey:kCATransactionAnimationDuration];
    
    [CATransaction setCompletionBlock:^{
        [self allowClicks:YES];
        [self removeFromSuperview];
    }];
    
    // Perform the animations
    self.circleLayer.fillColor = [[[UIColor colorWithCGColor:self.circleLayer.fillColor] colorWithAlphaComponent:0] CGColor];
    self.circleLayer.strokeColor = [[[UIColor colorWithCGColor:self.circleLayer.strokeColor] colorWithAlphaComponent:0] CGColor];
    
    self.backgroundCircleLayer.fillColor = [[[UIColor colorWithCGColor:self.backgroundCircleLayer.fillColor] colorWithAlphaComponent:0] CGColor];
    self.backgroundCircleLayer.strokeColor = [[[UIColor colorWithCGColor:self.backgroundCircleLayer.strokeColor] colorWithAlphaComponent:0] CGColor];
    
    self.backgroundLayer.fillColor = [[[UIColor colorWithCGColor:self.backgroundLayer.fillColor] colorWithAlphaComponent:0] CGColor];
    self.backgroundLayer.strokeColor = [[[UIColor colorWithCGColor:self.backgroundLayer.strokeColor] colorWithAlphaComponent:0] CGColor];
    
    [CATransaction commit];
}

#pragma mark circleCreation

- (void)createCircleIn:(CGRect)rect {
    CGPoint center = CGPointMake(rect.origin.x + self.radius, rect.origin.y + self.radius);
    
    if (self.style == MBLoaderLine) {
        _loaderPath = [UIBezierPath bezierPath];
        [_loaderPath moveToPoint:CGPointMake(rect.origin.x, rect.origin.y + self.radius)];
        [_loaderPath addLineToPoint:CGPointMake(rect.origin.x + (self.percentage/100.0f) * 2 * self.radius, rect.origin.y + self.radius)];
        
        _bufferPath = [UIBezierPath bezierPath];
        [_bufferPath moveToPoint:CGPointMake(rect.origin.x, rect.origin.y + self.radius)];
        [_bufferPath addLineToPoint:CGPointMake(rect.origin.x + 2 * self.radius, rect.origin.y + self.radius)];
    } else {
        _bufferPath = [UIBezierPath bezierPathWithArcCenter:center radius:self.radius startAngle:self.offset endAngle:(self.arcLength + self.offset) clockwise:YES];
        
        _loaderPath = [UIBezierPath bezierPathWithArcCenter:center radius:self.radius startAngle:self.offset endAngle:[self circleEndAngle] clockwise:YES];
    }
}

- (CGFloat)circleEndAngle
{
    return (self.percentage/(CGFloat)100) * self.arcLength + self.offset;
}

#pragma mark controllingPercentage

- (void)loadAnimation
{
    if (self.percentAnimating == NO){
        self.percentAnimating = YES;
        
        CGFloat cirOriginX = CGRectGetMidX(self.frame) - self.radius;
        CGFloat cirOriginY = CGRectGetMidY(self.frame) - self.radius;
        [self createCircleIn:CGRectMake(cirOriginX, cirOriginY, 2.0*self.radius, 2.0*self.radius)];
        
        NSNumber *fromVal = @(0.0f);
        if (self.prevPercentage != 0) {
            fromVal = [NSNumber numberWithFloat:((float)self.prevPercentage / (float)self.percentage)];
        }
        
        self.backgroundCircleLayer.path = [self.bufferPath CGPath];
        self.circleLayer.path = [self.loaderPath CGPath];
        
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = self.duration;
        pathAnimation.fromValue = (id)fromVal;
        pathAnimation.toValue = @(1.0f);
        
        [pathAnimation setValue:self.percentAnim forKey:self.animType];
        
        [pathAnimation setDelegate:self];
        
        [self.circleLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
        
        _prevPercentage = _percentage;
    }
}

- (void)incrementPercentageBy:(NSInteger)amount
{
    if (amount > 0 && self.percentage < 100) {
        _percentage += amount;
        
        if (self.percentage > 100) {
            _percentage = 100;
        }
        
        [self loadAnimation];
    }
}

#pragma mark properties

- (void)allowClicks:(BOOL)allow
{
    if (allow) {
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
        
            // Start interaction with application
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
    } else {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    }
}

- (void)setPercentage:(NSInteger)percentage
{
    //We never want to decrement the loading circle
    if (percentage > self.percentage) {
        _percentage = percentage;
    }
}

- (NSInteger)getPercentage
{
    return self.percentage;
}

- (void)setBufferColor:(UIColor *)bufferColor
{
    if (_bufferColor != bufferColor && self.endingAnimStarted == NO){
        if (self.bufferColorAnimating) {
            [self.bufferColorQueue addObject:bufferColor];
        } else {
            self.bufferColorAnimating = YES;
            
            [CATransaction begin];
            [CATransaction setValue:[NSNumber numberWithFloat:self.duration]
                         forKey:kCATransactionAnimationDuration];
            [CATransaction setCompletionBlock:^{
                [self bufferColorAnimEnded];
            }];
            
            // Perform the animations
            self.backgroundCircleLayer.strokeColor = [bufferColor CGColor];
            [CATransaction commit];
        
            _bufferColor = bufferColor;
        }
    }
}

- (void)bufferColorAnimEnded
{
    self.bufferColorAnimating = NO;
    if ([self.bufferColorQueue count] > 0) {
        UIColor *first = [self.bufferColorQueue firstObject];
        [self setBufferColor:first];
        
        [self.bufferColorQueue removeObjectAtIndex:0];
    }
}

- (void)setBackColor:(UIColor *)backColor
{
    backColor = [backColor colorWithAlphaComponent:self.alpha];
    
    if (self.backColor != backColor && self.endingAnimStarted == NO){
        if (self.backgroundColorAnimating) {
            [self.backgroundColorQueue addObject:backColor];
        } else {
            self.backgroundColorAnimating = YES;
            [CATransaction begin];
            [CATransaction setValue:[NSNumber numberWithFloat:self.duration]
                         forKey:kCATransactionAnimationDuration];
            [CATransaction setCompletionBlock:^{
                [self backColorAnimEnded];
            }];
            // Perform the animations
            self.backgroundLayer.strokeColor = [backColor CGColor];
            self.backgroundLayer.fillColor = [backColor CGColor];
            [CATransaction commit];
        
            _backColor = backColor;
        }
    }
}

- (void)backColorAnimEnded
{
    self.backgroundColorAnimating = NO;
    if ([self.backgroundColorQueue count] > 0) {
        UIColor *first = [self.backgroundColorQueue firstObject];
        [self setBackColor:first];
        
        [self.backgroundColorQueue removeObjectAtIndex:0];
    }
}

- (void)setLoadedColor:(UIColor *)loadedColor
{    
    if (_loadedColor != loadedColor && self.endingAnimStarted == NO){
        if (self.loadedColorAnimating) {
            [self.loadedColorQueue addObject:loadedColor];
        } else {
            self.loadedColorAnimating = YES;
            
            [CATransaction begin];
            [CATransaction setValue:[NSNumber numberWithFloat:self.duration]
                            forKey:kCATransactionAnimationDuration];
            [CATransaction setCompletionBlock:^{
                [self loadedColorAnimEnded];
            }];
            // Perform the animations
            self.circleLayer.strokeColor = [loadedColor CGColor];
            [CATransaction commit];
        
            _loadedColor = loadedColor;
        }
    }
}

- (void)loadedColorAnimEnded
{
    self.loadedColorAnimating = NO;
    if ([self.loadedColorQueue count] > 0) {
        UIColor *first = [self.loadedColorQueue firstObject];
        [self setLoadedColor:first];
        
        [self.loadedColorQueue removeObjectAtIndex:0];
    }
}

- (void)setWidth:(NSInteger)width
{
    if (width > 0 && self.endingAnimStarted == NO) {
        if (self.widthAnimating) {
            [self.widthQueue addObject:[NSNumber numberWithInteger:width]];
        } else {
            self.widthAnimating = YES;
            
            [CATransaction begin];
            [CATransaction setValue:[NSNumber numberWithFloat:self.duration]
                         forKey:kCATransactionAnimationDuration];
            [CATransaction setCompletionBlock:^{
                [self widthAnimEnded];
            }];
            
            // Perform the animations
            self.circleLayer.lineWidth = width;
            self.backgroundCircleLayer.lineWidth = width + self.buff;
            _width = width;
            [CATransaction commit];
        }
    }
}

- (void)setOuterLoaderBuffer:(NSInteger)buff
{
    if (buff >= 0) {
        _buff = buff;
        
        [CATransaction begin];
        [CATransaction setValue:[NSNumber numberWithFloat:self.duration]
                         forKey:kCATransactionAnimationDuration];
        [CATransaction setCompletionBlock:^{
            [self widthAnimEnded];
        }];
        // Perform the animations
        self.backgroundCircleLayer.lineWidth = self.width + buff;
        [CATransaction commit];
    }
}

- (void)widthAnimEnded
{
    self.widthAnimating = NO;
    if ([self.widthQueue count] > 0) {
        NSNumber *first = [self.widthQueue firstObject];
        [self setRadius:[first integerValue]];
        
        [self.widthQueue removeObjectAtIndex:0];
    }
}

- (void)setAlpha:(CGFloat)alpha
{
    if (alpha >= 0.0f && alpha <= 1.0f) {
        _alpha = alpha;
        [self setBackColor:self.backColor];
    }
}

//TODO: Make this animated
- (void)setRadius:(NSInteger)radius
{
    if (radius > 0 && self.loaderStarted == NO) {
        _radius = radius;
    }
}


- (void)offsetCenterXBy:(CGFloat)x_off
{
    self.x_center_offset += x_off;

    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:self.duration]
                         forKey:kCATransactionAnimationDuration];
    
    CATransform3D transform = CATransform3DMakeTranslation(self.x_center_offset, self.y_center_offset, 0);
    self.circleLayer.transform = transform;
    self.backgroundCircleLayer.transform = transform;
        
    [CATransaction commit];
}

- (void)offsetCenterYBy:(CGFloat)y_off
{
    self.y_center_offset += y_off;
    
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:self.duration]
                     forKey:kCATransactionAnimationDuration];
    
    CATransform3D transform = CATransform3DMakeTranslation(self.x_center_offset, self.y_center_offset, 0);
    self.circleLayer.transform = transform;
    self.backgroundCircleLayer.transform = transform;
    
    [CATransaction commit];
}

#pragma mark initialization

- (void)start {
    //Stops some values (like radius) from changing
    _loaderStarted = YES;
    
    CGFloat cirOriginX = CGRectGetMidX(self.frame) - self.radius;
    CGFloat cirOriginY = CGRectGetMidY(self.frame) - self.radius;
    
    [self createCircleIn:CGRectMake(cirOriginX, cirOriginY, 2.0*self.radius, 2.0*self.radius)];
    
    [self createLayers];
}

- (void)setLoaderStyle:(MBLoaderStyle)style
{
    self.style = style;
    
    if (self.loaderStarted == NO) {
        if (style == MBLoaderFullCircle) {
            _arcLength = 2* pi;
        } else if (style == MBLoaderHalfCircle) {
            _arcLength = pi;
            [self setStartPosition:MBLoaderLeft];
        } else if (style == MBLoaderLine) {
            //This is handled when creating the paths
        }
    }
}

- (void)setStartPosition:(MBLoaderStartPosition)startPos
{
    if (self.style == MBLoaderFullCircle) {
        if (startPos == MBLoaderLeft) {
            _offset = -pi;
        } else if (startPos == MBLoaderRight) {
            _offset = 0;
        } else if (startPos == MBLoaderTop) {
            _offset = -pi / 2;
        } else if (startPos == MBLoaderBottom) {
            _offset = pi / 2;
        }
    }
}

- (void)setLoaderSize:(MBLoaderSize)size
{
    CGFloat smallerSide = MIN(self.frame.size.width, self.frame.size.height);
    
    if (size == MBLoaderTiny) {
        self.radius = smallerSide * 0.05;
    } else if (size == MBLoaderSmall) {
        self.radius = smallerSide * 0.15;
    } else if (size == MBLoaderMedium) {
        self.radius = smallerSide * 0.25;
    } else if (size == MBLoaderLarge) {
        self.radius = smallerSide * 0.4;
    }
}

- (void)setAnimationSpeed:(MBLoaderSpeed)startPos
{
    if (startPos == MBLoaderSpeedSlow) {
        _duration = 2;
    } else if (startPos == MBLoaderSpeedMiddle) {
        _duration = 1;
    } else if (startPos == MBLoaderSpeedFast) {
        _duration = 0.5;
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //Set origin to top-left instead of center
        CGRect newFrame = CGRectMake(frame.origin.x + (frame.size.width / 2), frame.origin.y + (frame.size.height / 2), frame.size.width, frame.size.height);
        self.frame = newFrame;
        [self baseInit];
    }
    return self;
}

- (void)baseInit {
    if (self.frame.size.height == 0 || self.frame.size.width == 0) {
        self.frame = [[UIScreen mainScreen] bounds];
    }
    
    _backColor = [UIColor lightGrayColor];
    _loadedColor = [UIColor whiteColor];
    _bufferColor = [UIColor darkGrayColor];
    
    [self setAlpha:0.5];
    
    _animType = @"animType";
    
    [self setLoaderSize:MBLoaderMedium];
    
    _width = 7;
    _buff = 7;
    _alpha = 0.75;
    
    _percentage = 0;
    _prevPercentage = 0;
    
    _offset = -pi;
    _arcLength = 2* pi;
    
    _bufferPath = nil;
    _loaderPath = nil;
    
    _circleLayer = nil;
    _backgroundCircleLayer = nil;
    _backgroundLayer = nil;
    
    [self setAnimationSpeed:MBLoaderSpeedFast];
    
    _percentAnimating = NO;
    _percentAnim = @"percentAnim";
    
    _loaderStarted = NO;
    _endingAnimStarted = NO;
    
    _widthAnimating = NO;
    _widthQueue = [[NSMutableArray alloc] init];
    
    _loadedColorAnimating = NO;
    _loadedColorQueue = [[NSMutableArray alloc] init];
    
    _bufferColorAnimating = NO;
    _bufferColorQueue = [[NSMutableArray alloc] init];
    
    _backgroundColorAnimating = NO;
    _backgroundColorQueue = [[NSMutableArray alloc] init];
    
    _x_center_offset = 0;
    
    //Allows for translucent background
    self.opaque = NO;
}

- (void)createLayers
{
    [self allowClicks:NO];
    
    if (self.backgroundLayer == nil) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        
        shapeLayer.strokeColor = [self.backColor CGColor];
        shapeLayer.fillColor = [self.backColor CGColor];
        
        [self.layer addSublayer:shapeLayer];
        
        self.backgroundLayer = shapeLayer;
        
        self.backgroundLayer.path = [[UIBezierPath bezierPathWithRect:self.frame] CGPath];
    }
    
    if (self.backgroundCircleLayer == nil) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        
        shapeLayer.strokeColor = [self.bufferColor CGColor];
        shapeLayer.fillColor = nil;
        shapeLayer.lineWidth = _width + self.buff;
        shapeLayer.lineJoin = kCALineJoinBevel;
        
        [self.layer addSublayer:shapeLayer];
        
        self.backgroundCircleLayer = shapeLayer;
        
        self.backgroundCircleLayer.path = [self.bufferPath CGPath];
    }
    
    if (self.circleLayer == nil) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        
        shapeLayer.strokeColor = [self.loadedColor CGColor];
        shapeLayer.fillColor = nil;
        shapeLayer.lineWidth = _width;
        shapeLayer.lineJoin = kCALineJoinBevel;
        
        [self.layer addSublayer:shapeLayer];
        
        self.circleLayer = shapeLayer;
    }
    
    [self offsetCenterXBy:0];
    [self offsetCenterYBy:0];
    
    [self.circleLayer setLineCap:kCALineCapRound];
    [self.backgroundCircleLayer setLineCap:kCALineCapRound];
}

@end