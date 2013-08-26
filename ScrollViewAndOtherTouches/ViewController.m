//
//  ViewController.m
//  ScrollViewAndOtherTouches
//
//  Created by Claes Lillieskold on 2013-08-21.
//  Copyright (c) 2013 Claes Lillieskold. All rights reserved.
//

#import "ViewController.h"
#import "ContentView.h"
#import "GraphGestureRecognizer.h"

@interface ViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet ContentView *contentView;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) GraphGestureRecognizer *graphGestureRecognizer;
@property (assign, nonatomic) BOOL twoFingerTouchFromLongPress;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.contentSize = self.contentView.bounds.size;
    
    // Tap gesture recognizer.
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizer:)];
    self.tapGestureRecognizer.numberOfTapsRequired = 2;
    [self.contentView addGestureRecognizer:self.tapGestureRecognizer];
    
    // Graph gesture recognizer.
    self.graphGestureRecognizer = [[GraphGestureRecognizer alloc] initWithTarget:self action:@selector(graphRecognizer:)];
    [self.contentView addGestureRecognizer:self.graphGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tapRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    [self.contentView clearAllDots];
}

- (void)graphRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan ||
        gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        for (NSUInteger i = 0; i < [gestureRecognizer numberOfTouches]; i++) {
            CGPoint point = [gestureRecognizer locationOfTouch:i inView:self.contentView];
            if (i == 0) {
                [self.contentView drawGreenDotAtPoint:point];
            } else if (i == 1) {
                [self.contentView drawRedDotAtPoint:point];
            }
        }
    }
}

@end
