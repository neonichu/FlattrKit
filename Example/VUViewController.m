//
//  VUViewController.m
//  FlattrKit
//
//  Created by Boris Bügling on 14.01.12.
//  Copyright (c) 2012 Crocodil.us. All rights reserved.
//

#import "VUViewController.h"

@implementation VUViewController

-(void)loadView {
    self.view = [[UIView alloc] init];
}

-(void)viewDidLoad {
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(100, 200, 200, 100)];
    label.text = @"FlattrKit example";
    [self.view addSubview:label];
}

@end
