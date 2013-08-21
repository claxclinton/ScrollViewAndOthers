//
//  ViewController.m
//  ScrollViewAndOtherTouches
//
//  Created by Claes Lillieskold on 2013-08-21.
//  Copyright (c) 2013 Claes Lillieskold. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *contentView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.contentSize = self.contentView.bounds.size;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
