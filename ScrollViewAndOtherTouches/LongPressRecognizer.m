//
//  LongPressRecognizer.m
//  ScrollViewAndOtherTouches
//
//  Created by Claes Lillieskold on 2013-08-23.
//  Copyright (c) 2013 Claes Lillieskold. All rights reserved.
//

#import <UIKit/UIGestureRecognizerSubclass.h>
#import "LongPressRecognizer.h"

@implementation LongPressRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSAssert([touches count] == 1, @"");
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSAssert([touches count] == 1, @"");
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSAssert([touches count] == 1, @"");
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSAssert([touches count] == 1, @"");
}

@end
