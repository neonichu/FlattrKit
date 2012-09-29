//
//  VUAuthViewController.m
//  FlattrKit
//
//  Created by Boris Bügling on 14.01.12.
//  Copyright (c) 2012 Crocodil.us. All rights reserved.
//

#import "VUAuthViewController.h"

@interface VUAuthViewController ()

@property (nonatomic, strong) UIWebView* webView;

@end

#pragma mark -

@implementation VUAuthViewController

@synthesize delegate;
@synthesize redirectURL;
@synthesize webView;

#pragma mark -

-(void)loadView {
    self.webView = [[UIWebView alloc] init];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.webView.delegate = self;
    self.view = self.webView;
}

-(void)openURL:(NSURL*)url {
    if (!self.webView) {
        [self loadView];
    }
    
    NSAssert(self.webView, @"No webView available, cannot load URL.");
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

#pragma mark -
#pragma mark UIWebView delegate

-(void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navType {
    if ([[request.URL absoluteString] hasPrefix:[self.redirectURL absoluteString]]) {
        [self.delegate handleURL:request.URL];
        [self webViewDidFinishLoad:self.webView];
        return NO;
    }
    return YES;
}

@end
