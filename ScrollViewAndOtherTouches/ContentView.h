//
//  VIew.h
//  ScrollViewAndOtherTouches
//
//  Created by Claes Lillieskold on 2013-08-21.
//  Copyright (c) 2013 Claes Lillieskold. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentView : UIView

- (void)clearAllDots;
- (void)drawBlueDotAtPoint:(CGPoint)point;
- (void)drawRedDotAtPoint:(CGPoint)point;
- (void)drawGreenDotAtPoint:(CGPoint)point;
- (void)drawBlackDotAtPoint:(CGPoint)point;

@end
