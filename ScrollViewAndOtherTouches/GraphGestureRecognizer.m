//
//  GraphGestureRecognizer.m
//  ScrollViewAndOtherTouches
//
//  Created by Claes Lillieskold on 2013-08-26.
//  Copyright (c) 2013 Claes Lillieskold. All rights reserved.
//

#import <UIKit/UIGestureRecognizerSubclass.h>
#import "GraphGestureRecognizer.h"

typedef enum kRecognitionStartCondition {
    kRecognitionStartConditionInactive = 0,
    kRecognitionStartConditionOngoing = 1,
    kRecognitionStartConditionFailed = 2
} kRecognitionStartCondition;

@interface GraphGestureRecognizer ()
@property (assign, nonatomic) kRecognitionStartCondition startConditionState;
@end

@implementation GraphGestureRecognizer

- (id)initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithTarget:target action:action];
    if (self) {
        self.startConditionState = kRecognitionStartConditionInactive;
    }
    return self;
}

- (void)ignoreTouch:(UITouch*)touch forEvent:(UIEvent*)event
{
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
    self.startConditionState = kRecognitionStartConditionInactive;
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
    if ([touches count] == 2) {
        self.state = UIGestureRecognizerStateBegan;
    } else {
        if (self.state != UIGestureRecognizerStateChanged) {
            self.state = UIGestureRecognizerStateFailed;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.state == UIGestureRecognizerStateBegan) {
        self.state = UIGestureRecognizerStateChanged;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([[event allTouches] count] == 1) {
        self.state = UIGestureRecognizerStateCancelled;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.state = UIGestureRecognizerStateCancelled;
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
