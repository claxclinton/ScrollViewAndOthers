//
//  LongPressRecognizer.h
//  ScrollViewAndOtherTouches
//
//  Created by Claes Lillieskold on 2013-08-23.
//  Copyright (c) 2013 Claes Lillieskold. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LongPressRecognizer : UIGestureRecognizer
@property (assign, nonatomic) CFTimeInterval minimumPressDuration;
@end
