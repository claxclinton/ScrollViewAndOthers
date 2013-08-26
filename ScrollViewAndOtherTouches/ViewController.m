//
//  ViewController.m
//  ScrollViewAndOtherTouches
//
//  Created by Claes Lillieskold on 2013-08-21.
//  Copyright (c) 2013 Claes Lillieskold. All rights reserved.
//

#import "ViewController.h"
#import "ContentView.h"
#import "PinchRecognizer.h"
#import "LongPressRecognizer.h"

@interface ViewController () <UIScrollViewDelegate, LongPressRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet ContentView *contentView;
@property (strong, nonatomic) LongPressRecognizer *longPressRecognizer;
@property (strong, nonatomic) PinchRecognizer *pinchGestureRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (assign, nonatomic) BOOL twoFingerTouchFromLongPress;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.contentSize = self.contentView.bounds.size;
    
    // Long press
    self.longPressRecognizer = [[LongPressRecognizer alloc]
                                initWithTarget:self action:@selector(longPressRecognizer:)];
    self.longPressRecognizer.minimumPressDuration = 1.0;
    self.longPressRecognizer.customDelegate = self;
    [self.contentView addGestureRecognizer:self.longPressRecognizer];
    
    // Tap
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self action:@selector(tapRecognizer:)];
    self.tapGestureRecognizer.numberOfTapsRequired = 2;
    [self.contentView addGestureRecognizer:self.tapGestureRecognizer];
    
    // Pinch
    self.pinchGestureRecognizer = [[PinchRecognizer alloc] initWithTarget:self action:@selector(pinchRecognizer:)];
    [self.contentView addGestureRecognizer:self.pinchGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizerStateEndedCanceledFailed:(UIGestureRecognizer *)gestureRecognizer {
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
            return YES;
        default:
            return NO;
    }
}

- (void)longPressRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:self.contentView];
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan || gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        [self.contentView drawBlueDotAtPoint:point];
    } else {
        [self.contentView drawBlackDotAtPoint:point];
    }
}

- (void)longPressRecognizer:(LongPressRecognizer *)longPressRecognizer secondTouchStartAtPoint:(CGPoint)point {
    self.twoFingerTouchFromLongPress = YES;
    [self.contentView drawRedDotAtPoint:point];
}

- (void)longPressRecognizer:(LongPressRecognizer *)longPressRecognizer secondTouchMovedToPoint:(CGPoint)point {
    [self.contentView drawRedDotAtPoint:point];
}

- (void)longPressRecognizer:(LongPressRecognizer *)longPressRecognizer secondTouchEndAtPoint:(CGPoint)point {
    self.twoFingerTouchFromLongPress = NO;
}

- (void)pinchRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    NSUInteger numberOfTouches = [gestureRecognizer numberOfTouches];
    
    if ([self gestureRecognizerStateEndedCanceledFailed:gestureRecognizer]) {
        for (NSUInteger i = 0; i < numberOfTouches; i++) {
            CGPoint point = [gestureRecognizer locationOfTouch:i inView:self.contentView];
            [self.contentView drawBlackDotAtPoint:point];
        }
        return;
    }
    
    switch (numberOfTouches) {
        case 1:
        {
            CGPoint point = [gestureRecognizer locationOfTouch:0 inView:self.contentView];
            [self.contentView drawBlueDotAtPoint:point];
        }
            break;
        case 2:
        {
            CGPoint point1 = [gestureRecognizer locationOfTouch:0 inView:self.contentView];
            CGPoint point2 = [gestureRecognizer locationOfTouch:1 inView:self.contentView];
            CGPoint leftPoint;
            CGPoint rightPoint;
            if (point1.x < point2.x) {
                leftPoint = point1;
                rightPoint = point2;
            } else {
                leftPoint = point2;
                rightPoint = point1;
            }
            [self.contentView drawRedDotAtPoint:leftPoint];
            [self.contentView drawGreenDotAtPoint:rightPoint];
        }
            break;
            
        default:
            break;
    }
}

- (void)tapRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    [self.contentView clearAllDots];
}

@end
