//
//  GraphGestureRecognizer.m
//  ScrollViewAndOtherTouches
//
//  Created by Claes Lillieskold on 2013-08-26.
//  Copyright (c) 2013 Claes Lillieskold. All rights reserved.
//

#import <UIKit/UIGestureRecognizerSubclass.h>
#import "GraphGestureRecognizer.h"

@interface LongPressTouch : NSObject <NSCopying>
@property (assign, nonatomic) NSTimeInterval timestamp;
@property (assign, nonatomic) CGPoint point;
- (id)initWithTouch:(UITouch *)touch;
- (id)copyWithZone:(NSZone *)zone;
@end

@implementation LongPressTouch
- (id)initWithTouch:(UITouch *)touch
{
    self = [super init];
    if (self) {
        self.timestamp = touch.timestamp;
        self.point = [touch locationInView:touch.view];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    LongPressTouch *longPressTouch = [[LongPressTouch allocWithZone:zone] init];
    if (longPressTouch) {
        longPressTouch.timestamp = self.timestamp;
        longPressTouch.point = self.point;
    }
    return longPressTouch;
}
@end

@interface GraphGestureRecognizer ()
@property (strong, nonatomic) NSTimer *longPressTimer;
@property (strong, nonatomic) NSMutableArray *longPressTouches;
@end

@implementation GraphGestureRecognizer

#pragma mark - Init

- (id)initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithTarget:target action:action];
    if (self) {
        self.longPressTouches = [NSMutableArray array];
    }
    return self;
}

#pragma mark - UIGestureRecognizer subclass

- (void)ignoreTouch:(UITouch*)touch forEvent:(UIEvent*)event
{
    [super ignoreTouch:touch forEvent:event];
}

// if a touch isn't part of this gesture it can be passed to this method to be ignored. ignored touches won't be cancelled on the view even if cancelsTouchesInView is YES

// the following methods are to be overridden by subclasses of UIGestureRecognizer
// if you override one you must call super

// called automatically by the runtime after the gesture state has been set to UIGestureRecognizerStateEnded
// any internal state should be reset to prepare for a new attempt to recognize the gesture
// after this is received all remaining active touches will be ignored (no further updates will be received for touches that had already begun but haven't ended)
- (void)reset
{
    self.state = UIGestureRecognizerStatePossible;
    [self.longPressTouches removeAllObjects];
    [self cancelTimer];
}

// same behavior as the equivalent delegate methods, but can be used by subclasses to define class-wide prevention rules
// for example, a UITapGestureRecognizer never prevents another UITapGestureRecognizer with a higher tap count
- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer
{
    return (self.state == UIGestureRecognizerStateBegan) || (self.state == UIGestureRecognizerStateChanged);
}

- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventingGestureRecognizer
{
    return NO;
}

// mirror of the touch-delivery methods on UIResponder
// UIGestureRecognizers aren't in the responder chain, but observe touches hit-tested to their view and their view's subviews
// UIGestureRecognizers receive touches before the view to which the touch was hit-tested
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([touches count] == 1) {
        if (self.state == UIGestureRecognizerStatePossible) {
            [self addLongPressTouchFromTouch:[touches anyObject]];
            if (self.longPressTimer) {
                if (![self isTouchesNarrowlyGrouped]) {
                    self.state = UIGestureRecognizerStateFailed;
                }
            } else {
                [self startTimer];
            }
        }
    } else if ([touches count] == 2) {
        [self cancelTimer];
        self.state = UIGestureRecognizerStateBegan;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.state == UIGestureRecognizerStateBegan) {
        self.state = UIGestureRecognizerStateChanged;
    } else if ((self.state == UIGestureRecognizerStatePossible) &&
               ([touches count] == 1)) {
        [self addLongPressTouchFromTouch:[touches anyObject]];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self cancelTimer];
    if ([[event allTouches] count] == 1) {
        self.state = UIGestureRecognizerStateEnded;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self cancelTimer];
    self.state = UIGestureRecognizerStateCancelled;
}

#pragma mark - Timer

- (void)startTimer
{
    self.longPressTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerTriggered)
                                                userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.longPressTimer forMode:NSDefaultRunLoopMode];
}

- (void)cancelTimer
{
    [self.longPressTimer invalidate];
    self.longPressTimer = nil;
}

- (void)timerTriggered
{
    if (self.numberOfTouches == 1) {
        if ([self isTouchesNarrowlyGrouped]) {
            self.state = UIGestureRecognizerStateBegan;
        } else {
            self.state = UIGestureRecognizerStateFailed;
        }
    }
    [self cancelTimer];
}

#pragma mark - Long touch evaluation data

- (BOOL)isTouchesNarrowlyGrouped
{
    __block CGFloat minX;
    __block CGFloat minY;
    __block CGFloat maxX;
    __block CGFloat maxY;
    [self.longPressTouches enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        LongPressTouch *longPressTouch = (LongPressTouch *)obj;
        if (idx == 0) {
            minX = longPressTouch.point.x;
            minY = longPressTouch.point.y;
            maxX = longPressTouch.point.x;
            maxY = longPressTouch.point.y;
        } else {
            minX = MIN(minX, longPressTouch.point.x);
            minY = MIN(minY, longPressTouch.point.y);
            maxX = MAX(maxX, longPressTouch.point.x);
            maxY = MAX(maxY, longPressTouch.point.y);
        }
    }];
    
    BOOL isXWithinLimitedArea = (maxX - minX) < 5.0;
    BOOL isYWithinLimitedArea = (maxY - minY) < 5.0;
    BOOL isWithinLimitedArea = (isXWithinLimitedArea && isYWithinLimitedArea);
    return isWithinLimitedArea;
}

- (void)addLongPressTouchFromTouch:(UITouch *)touch
{
    LongPressTouch *longPressTouch = [[LongPressTouch alloc] initWithTouch:touch];
    [self.longPressTouches addObject:longPressTouch];
}

#pragma mark - Debug

- (NSString *)stringFromRecognizerState:(UIGestureRecognizerState)state
{
    switch (state) {
        case UIGestureRecognizerStatePossible:
            return @"UIGestureRecognizerStatePossible";
        case UIGestureRecognizerStateBegan:
            return @"UIGestureRecognizerStateBegan";
        case UIGestureRecognizerStateChanged:
            return @"UIGestureRecognizerStateChanged";
        case UIGestureRecognizerStateEnded:
            return @"UIGestureRecognizerStateEnded";
        case UIGestureRecognizerStateCancelled:
            return @"UIGestureRecognizerStateCancelled";
        case UIGestureRecognizerStateFailed:
            return @"UIGestureRecognizerStateFailed";
        default:
            return  nil;
    }
}

- (void)setState:(UIGestureRecognizerState)state
{
    NSLog(@"STATE: %@ --> %@", [self stringFromRecognizerState:self.state],
          [self stringFromRecognizerState:state]);
    [super setState:state];
}

@end
