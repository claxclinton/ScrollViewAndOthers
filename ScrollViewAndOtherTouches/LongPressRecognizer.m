//
//  LongPressRecognizer.m
//  ScrollViewAndOtherTouches
//
//  Created by Claes Lillieskold on 2013-08-23.
//  Copyright (c) 2013 Claes Lillieskold. All rights reserved.
//

#import <UIKit/UIGestureRecognizerSubclass.h>
#import "LongPressRecognizer.h"

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

@interface LongPressRecognizer ()
@property (strong, nonatomic) NSMutableArray *longPressTouches;
@end

@implementation LongPressRecognizer

- (id)initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithTarget:target action:action];
    if (self) {
        self.longPressTouches = [NSMutableArray array];
        self.minimumPressDuration = 0;
    }
    return self;
}

// if a touch isn't part of this gesture it can be passed to this method to be ignored. ignored touches won't be cancelled on the view even if cancelsTouchesInView is YES
- (void)ignoreTouch:(UITouch*)touch forEvent:(UIEvent*)event
{
    [super ignoreTouch:touch forEvent:event];
}

// called automatically by the runtime after the gesture state has been set to UIGestureRecognizerStateEnded
// any internal state should be reset to prepare for a new attempt to recognize the gesture
// after this is received all remaining active touches will be ignored (no further updates will be received for touches that had already begun but haven't ended)
- (void)reset
{
    [super reset];
    [self.longPressTouches removeAllObjects];
}

// same behavior as the equivalent delegate methods, but can be used by subclasses to define class-wide prevention rules
// for example, a UITapGestureRecognizer never prevents another UITapGestureRecognizer with a higher tap count
- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer
{
    return [super canPreventGestureRecognizer:preventedGestureRecognizer];
}

- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventingGestureRecognizer
{
    return [super canBePreventedByGestureRecognizer:preventingGestureRecognizer];
}

// mirror of the touch-delivery methods on UIResponder
// UIGestureRecognizers aren't in the responder chain, but observe touches hit-tested to their view and their view's subviews
// UIGestureRecognizers receive touches before the view to which the touch was hit-tested

- (UITouch *)singleTouchFromTouches:(NSSet *)touches
{
    UITouch *touch = [touches anyObject];
    return touch;
}

- (void)logTouches
{
    [self.longPressTouches enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        LongPressTouch *longPressTouch = obj;
        NSLog(@"touch[%d] timestamp:%f point:%@", idx, longPressTouch.timestamp,
              NSStringFromCGPoint(longPressTouch.point));
    }];
}

- (BOOL)isTouchesWithinLimitedArea
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

- (BOOL)longPressDetected
{
    if ([self.longPressTouches count] > 1) {
        LongPressTouch *first = [self.longPressTouches objectAtIndex:0];
        LongPressTouch *last = [self.longPressTouches lastObject];
        CFTimeInterval totalTime = (last.timestamp - first.timestamp);
        if (totalTime > self.minimumPressDuration) {
            BOOL isWithinLimitedArea = [self isTouchesWithinLimitedArea];
            return isWithinLimitedArea;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [self singleTouchFromTouches:touches];
    LongPressTouch *longPressTouch = [[LongPressTouch alloc] initWithTouch:touch];
    [self.longPressTouches addObject:longPressTouch];
    self.state = UIGestureRecognizerStatePossible;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [self singleTouchFromTouches:touches];
    LongPressTouch *longPressTouch = [[LongPressTouch alloc] initWithTouch:touch];
    [self.longPressTouches addObject:longPressTouch];
    if (self.state == UIGestureRecognizerStatePossible && [self longPressDetected]) {
        self.state = UIGestureRecognizerStateRecognized;
    } else {
        self.state = UIGestureRecognizerStateFailed;
        [self ignoreTouch:touch forEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [self singleTouchFromTouches:touches];
    LongPressTouch *longPressTouch = [[LongPressTouch alloc] initWithTouch:touch];
    [self.longPressTouches addObject:longPressTouch];
    [self logTouches];
    self.state = UIGestureRecognizerStateEnded;
}

- (void)touchesCancelled:(NSSet *)touches withEveent:(UIEvent *)event
{
    UITouch *touch = [self singleTouchFromTouches:touches];
    LongPressTouch *longPressTouch = [[LongPressTouch alloc] initWithTouch:touch];
    [self.longPressTouches addObject:longPressTouch];
    [self logTouches];
    self.state = UIGestureRecognizerStateCancelled;
}

@end
