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

- (void)logStateForTwoTouches:(NSSet *)touches {
    if ([touches count] == 2) {
        NSLog(@"state=%d", self.state);
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self logStateForTwoTouches:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    [self logStateForTwoTouches:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self logStateForTwoTouches:touches];
}

- (void)touchesCancelled:(NSSet *)touches withEveent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    [self logStateForTwoTouches:touches];
}

@end
