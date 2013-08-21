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
