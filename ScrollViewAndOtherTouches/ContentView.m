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
@property (strong, nonatomic) NSMutableArray *allGreenPoints;
@property (strong, nonatomic) NSMutableArray *allBlackPoints;
@end

@implementation ContentView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _allBluePoints = [NSMutableArray array];
    _allGreenPoints = [NSMutableArray array];
    _allRedPoints = [NSMutableArray array];
    _allBlackPoints = [NSMutableArray array];
}

- (void)clearAllDots {
    [self.allBluePoints removeAllObjects];
    [self.allRedPoints removeAllObjects];
    [self.allGreenPoints removeAllObjects];
    [self.allBlackPoints removeAllObjects];
    [self setNeedsDisplay];
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

- (void)drawExistingGreenDots {
    for (NSValue *value in self.allGreenPoints) {
        CGPoint point = [value CGPointValue];
        [self drawCircleWithColor:[UIColor greenColor] atPoint:point];
    }
}

- (void)drawExistingBlackDots {
    for (NSValue *value in self.allBlackPoints) {
        CGPoint point = [value CGPointValue];
        [self drawCircleWithColor:[UIColor yellowColor] atPoint:point];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [[UIImage imageNamed:@"1.png"] drawInRect:rect];
    
    [self drawExistingBlueDots];
    [self drawExistingRedDots];
    [self drawExistingGreenDots];
    [self drawExistingBlackDots];
}

- (void)drawBlueDotAtPoint:(CGPoint)point {
    [self.allBluePoints addObject:[NSNumber valueWithCGPoint:point]];
    [self setNeedsDisplay];
}

- (void)drawRedDotAtPoint:(CGPoint)point {
    [self.allRedPoints addObject:[NSNumber valueWithCGPoint:point]];
    [self setNeedsDisplay];
}

- (void)drawGreenDotAtPoint:(CGPoint)point {
    [self.allGreenPoints addObject:[NSNumber valueWithCGPoint:point]];
    [self setNeedsDisplay];
}

- (void)drawBlackDotAtPoint:(CGPoint)point {
    [self.allBlackPoints addObject:[NSNumber valueWithCGPoint:point]];
    [self setNeedsDisplay];
}

- (void)setTransform:(CGAffineTransform)transform {
    [super setTransform:transform];
    NSLog(@"setTransform");
}

@end
