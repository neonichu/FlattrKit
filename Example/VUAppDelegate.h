//
//  VUAppDelegate.h
//  FlattrKit
//
//  Created by Boris Bügling on 14.01.12.
//  Copyright (c) 2012 Crocodil.us. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VUFlattr;

@interface VUAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) VUFlattr *flattrClient;

@end
