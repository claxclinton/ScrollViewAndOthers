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
@property (assign, nonatomic) BOOL twoFingerTouch;
@end

@implementation LongPressRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

- (UITouch *)secondTouchFromEvent:(UIEvent *)event
{
    if ([[event allTouches] count] == 1) {
        return nil;
    }
    __block UITouch *secondTouch = nil;
    [event.allTouches enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        secondTouch = (UITouch *)obj;
        if (secondTouch.view != nil) {
            *stop = YES;
        }
    }];
    return secondTouch;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *secondFingerTouch = [self secondTouchFromEvent:event];
    if (secondFingerTouch) {
        CGPoint point = [secondFingerTouch locationInView:self.view];
        if (self.twoFingerTouch) {
            [self.customDelegate longPressRecognizer:self secondTouchMovedToPoint:point];
        } else {
            [self.customDelegate longPressRecognizer:self secondTouchStartAtPoint:point];
            self.twoFingerTouch = YES;
        }
    } else {
        if (self.twoFingerTouch) {
            [self.customDelegate longPressRecognizer:self secondTouchEndAtPoint:CGPointZero];
        }
    }
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}

@end
