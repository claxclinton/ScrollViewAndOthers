//
//  LongPressRecognizer.m
//  ScrollViewAndOtherTouches
//
//  Created by Claes Lillieskold on 2013-08-23.
//  Copyright (c) 2013 Claes Lillieskold. All rights reserved.
//

#import <UIKit/UIGestureRecognizerSubclass.h>
#import "LongPressRecognizer.h"

@interface LongPressRecognizer ()
@property (strong, nonatomic) NSMutableArray *touches;
@property (assign, nonatomic) CFTimeInterval totalPressDuration;
@end

@implementation LongPressRecognizer

- (id)initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithTarget:target action:action];
    if (self) {
        self.touches = [NSMutableArray array];
    }
    return self;
}

// if a touch isn't part of this gesture it can be passed to this method to be ignored. ignored touches won't be cancelled on the view even if cancelsTouchesInView is YES
- (void)ignoreTouch:(UITouch*)touch forEvent:(UIEvent*)event
{
    [super ignoreTouch:touch forEvent:event];
}

- (void)logTimeStampOfTouches
{
    for (NSUInteger i = 0; i < [self.touches count]; i++) {
        UITouch *touch = [self.touches objectAtIndex:i];
        NSLog(@"Timestamp[%d].timeStamp = %f", i, touch.timestamp);
    }
}

// called automatically by the runtime after the gesture state has been set to UIGestureRecognizerStateEnded
// any internal state should be reset to prepare for a new attempt to recognize the gesture
// after this is received all remaining active touches will be ignored (no further updates will be received for touches that had already begun but haven't ended)
- (void)reset
{
    [super reset];
//    [self logTimeStampOfTouches];
    [self.touches removeAllObjects];
    NSLog(@"reset: totalPressDuration %f", self.totalPressDuration);
    self.totalPressDuration = 0;
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

- (void)logStateForTouches:(NSSet *)touche
{
//    static NSUInteger instanceNumber = 0;
//    NSLog(@"Number of touches[%d]: %d", instanceNumber++, [touches count]);
}

// mirror of the touch-delivery methods on UIResponder
// UIGestureRecognizers aren't in the responder chain, but observe touches hit-tested to their view and their view's subviews
// UIGestureRecognizers receive touches before the view to which the touch was hit-tested

- (CFTimeInterval)timeBetweenFirstAndLastTouch
{
    UITouch *firstTouch = [self.touches objectAtIndex:0];
    UITouch *lastTouch = [self.touches lastObject];
    CFTimeInterval totalDurationTime = (lastTouch.timestamp - firstTouch.timestamp);
    return totalDurationTime;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    self.state = UITouchPhaseBegan;
    NSUInteger numberOfTouches = [touches count];
    if (numberOfTouches == 1) {
        UITouch *touch = [touches anyObject];
        [self.touches addObject:touch];
    }
    [self logStateForTouches:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    self.state = UITouchPhaseMoved;
    [super touchesMoved:touches withEvent:event];
    NSUInteger numberOfTouches = [touches count];
    if (numberOfTouches == 1) {
        UITouch *anyTouch = [touches anyObject];
        [self.touches addObject:anyTouch];
        self.totalPressDuration = [self timeBetweenFirstAndLastTouch];
    }
    [self logStateForTouches:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.state = UITouchPhaseEnded;
    [self reset];
    [super touchesEnded:touches withEvent:event];
    [self logStateForTouches:touches];
}

- (void)touchesCancelled:(NSSet *)touches withEveent:(UIEvent *)event {
    self.state = UITouchPhaseCancelled;
    [self reset];
    [super touchesCancelled:touches withEvent:event];
    [self logStateForTouches:touches];
}

@end
