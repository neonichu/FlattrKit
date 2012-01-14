//
//  VUAuthViewController.h
//  FlattrKit
//
//  Created by Boris Bügling on 14.01.12.
//  Copyright (c) 2012 Crocodil.us. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VUAuthRedirectDelegate <NSObject>

-(void)handleURL:(NSURL*)url;

@end

#pragma mark -

@interface VUAuthViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) NSURL* redirectURL;
@property (nonatomic, weak) id<VUAuthRedirectDelegate> delegate;

-(void)openURL:(NSURL*)url;

@end
