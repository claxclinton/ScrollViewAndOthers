//
//  VIew.m
//  ScrollViewAndOtherTouches
//
//  Created by Claes Lillieskold on 2013-08-21.
//  Copyright (c) 2013 Claes Lillieskold. All rights reserved.
//

#import "ContentView.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

@interface ContentView ()

@property (assign, nonatomic) CGPoint bluePoint;
@property (strong, nonatomic) NSMutableArray *allBluePoints;

@end

@implementation ContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)internalDrawBlueCircleAtPoint:(CGPoint)point {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(context, CGRectMake(point.x - 2.0, point.y - 2.0, 4.0, 4.0));
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (void)drawExistingBlueDots {
    for (NSValue *value in self.allBluePoints) {
        CGPoint point = [value CGPointValue];
        [self internalDrawBlueCircleAtPoint:point];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [[UIImage imageNamed:@"1.png"] drawInRect:rect];
    if (!CGPointEqualToPoint(self.bluePoint, CGPointZero)) {
        if (self.allBluePoints == nil) {
            self.allBluePoints = [NSMutableArray array];
        }
        [self.allBluePoints addObject:[NSValue valueWithCGPoint:self.bluePoint]];
        self.bluePoint = CGPointZero;
    }
    
    [self drawExistingBlueDots];
}

- (void)drawBlueDotAtPoint:(CGPoint)point {
    self.bluePoint = point;
    [self setNeedsDisplay];
}

@end
