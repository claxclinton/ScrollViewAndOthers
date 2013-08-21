//
//  ViewController.m
//  ScrollViewAndOtherTouches
//
//  Created by Claes Lillieskold on 2013-08-21.
//  Copyright (c) 2013 Claes Lillieskold. All rights reserved.
//

#import "ViewController.h"
#import "ContentView.h"

@interface ViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet ContentView *contentView;
@property (strong, nonatomic) UILongPressGestureRecognizer *longPressRecognizer;
@property (strong, nonatomic) UIPinchGestureRecognizer *pinchGestureRecognizer;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.contentSize = self.contentView.bounds.size;
    self.longPressRecognizer = [[UILongPressGestureRecognizer alloc]
                                initWithTarget:self action:@selector(longPressRecognizer:)];
    self.longPressRecognizer.minimumPressDuration = 1.0;
    [self.contentView addGestureRecognizer:self.longPressRecognizer];
    
    self.pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchRecognizer:)];
    [self.contentView addGestureRecognizer:self.pinchGestureRecognizer];
}

- (void)pinchRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    static NSUInteger counter = 0;
    NSUInteger numberOfTouches = [gestureRecognizer numberOfTouches];
    NSMutableArray *redDotPoints = [NSMutableArray array];
    for (NSUInteger touchIndex = 0; touchIndex < numberOfTouches; touchIndex++) {
        CGPoint point = [gestureRecognizer locationOfTouch:touchIndex inView:self.contentView];
        [redDotPoints addObject:[NSNumber valueWithCGPoint:point]];
    }
    [self.contentView drawRedDotAtPoints:redDotPoints];
    counter++;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)longPressRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:self.contentView];
    [self.contentView drawBlueDotAtPoint:point];
}

@end
