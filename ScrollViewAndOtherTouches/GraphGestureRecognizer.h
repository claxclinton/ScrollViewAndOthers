//
//  GraphGestureRecognizer.h
//  ScrollViewAndOtherTouches
//
//  Created by Claes Lillieskold on 2013-08-26.
//  Copyright (c) 2013 Claes Lillieskold. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraphGestureRecognizer : UIGestureRecognizer
@property (assign, nonatomic) CFTimeInterval minimumPressDuration;
@end
