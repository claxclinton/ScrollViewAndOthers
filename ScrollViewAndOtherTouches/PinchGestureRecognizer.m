//
//  PinchGestureRecognizer.m
//  ScrollViewAndOtherTouches
//
//  Created by Claes Lillieskold on 2013-08-23.
//  Copyright (c) 2013 Claes Lillieskold. All rights reserved.
//

#import "PinchGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation PinchGestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches count] == 2) {
        self.state = UIGestureRecognizerStateBegan;
    }
}

@end
