//
//  LongPressRecognizer.h
//  ScrollViewAndOtherTouches
//
//  Created by Claes Lillieskold on 2013-08-23.
//  Copyright (c) 2013 Claes Lillieskold. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LongPressRecognizer;

@protocol LongPressRecognizerDelegate
- (void)longPressRecognizer:(LongPressRecognizer *)longPressRecognizer
    secondTouchStartAtPoint:(CGPoint)point;
- (void)longPressRecognizer:(LongPressRecognizer *)longPressRecognizer
    secondTouchMovedToPoint:(CGPoint)point;
- (void)longPressRecognizer:(LongPressRecognizer *)longPressRecognizer
    secondTouchEndAtPoint:(CGPoint)point;
@end

@interface LongPressRecognizer : UILongPressGestureRecognizer
@property (weak, nonatomic) id <LongPressRecognizerDelegate> customDelegate;
@end
