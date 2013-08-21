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
@property (strong, nonatomic) NSMutableArray *allRedPoints;

@end

@implementation ContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)drawCircleWithColor:(UIColor *)color atPoint:(CGPoint)point {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextAddEllipseInRect(context, CGRectMake(point.x - 2.0, point.y - 2.0, 4.0, 4.0));
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (void)drawExistingBlueDots {
    for (NSValue *value in self.allBluePoints) {
        CGPoint point = [value CGPointValue];
        [self drawCircleWithColor:[UIColor blueColor] atPoint:point];
    }
}

- (void)drawExistingRedDots {
    for (NSValue *value in self.allRedPoints) {
        CGPoint point = [value CGPointValue];
        [self drawCircleWithColor:[UIColor redColor] atPoint:point];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [[UIImage imageNamed:@"1.png"] drawInRect:rect];
    
    
    // Blue points
    if (self.allBluePoints == nil) {
        self.allBluePoints = [NSMutableArray array];
    }
    if (!CGPointEqualToPoint(self.bluePoint, CGPointZero)) {
        [self.allBluePoints addObject:[NSValue valueWithCGPoint:self.bluePoint]];
        self.bluePoint = CGPointZero;
    }
    
    // Red points
    if (self.allRedPoints == nil) {
        self.allRedPoints = [NSMutableArray array];
    }
    
    [self drawExistingBlueDots];
    [self drawExistingRedDots];
}

- (void)drawBlueDotAtPoint:(CGPoint)point {
    self.bluePoint = point;
    [self setNeedsDisplay];
}

- (void)drawRedDotAtPoints:(NSArray *)points {
    [self.allRedPoints addObjectsFromArray:points];
    [self setNeedsDisplay];
}

- (void)setTransform:(CGAffineTransform)transform {
    [super setTransform:transform];
    NSLog(@"setTransform");
}

@end
