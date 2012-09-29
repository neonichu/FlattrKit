//
//  VUFlattrActivity.m
//  FlattrKit
//
//  Created by Boris Buegling on 29.09.12.
//  Copyright (c) 2012 Crocodil.us. All rights reserved.
//

#import "FlattrKit.h"
#import "VUFlattrActivity.h"

// Don't forget to change these values, they here just for demo purposes.
static NSString* const kOAuthKey    = @"G8LwBUlkvxqhkpmP7U25IBp2loGTsBvYz6k1QwccTsk4IwJGhCCQ4RIf5eYoFjc5";
static NSString* const kOAuthSecret = @"gnXWJZZti9nQvXmDqOjkwSpsWeGsoJouWchw27Qa64QsR3V8I5i4NynADTSRt7cg";

@interface VUFlattrActivity () <VUFlattrAuthHandler>

@property (nonatomic, strong) VUAuthViewController* authViewController;
@property (nonatomic, strong) VUFlattr* flattrClient;
@property (nonatomic, strong) NSURL* url;

@end

#pragma mark -

@implementation VUFlattrActivity

#pragma mark - Activity information

-(UIImage*)activityImage {
    return [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FlattrActivityImage" ofType:@"png"]];
}

-(NSString*)activityTitle {
    return @"Flattr";
}

-(NSString*)activityType {
    return @"vu0.org.FlattrKit";
}

-(UIViewController*)activityViewController {
    return self.authViewController;
}

#pragma mark - Perform the activity

-(BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    return activityItems.count == 1 && [[activityItems lastObject] isKindOfClass:[NSURL class]];
}

-(void)performActivity {
    VUFlattrActivity* sself = self;
    
    [self.flattrClient loginWithCompletionHandler:^(VUFlattrUser *user, NSError *error) {
        if (!user) {
            [sself presentError:error];
            return;
        }
        
        [sself didPerformFlattrAuthenticationWithUser:user];
    } scope:VUFlattrScope_Flattr];
}

-(void)prepareWithActivityItems:(NSArray *)activityItems {
    self.url = [activityItems lastObject];
    
    if (!self.flattrClient) {
        self.flattrClient = [VUFlattr flattr];
        
        [self.flattrClient setAuthHandler:self];
        [self.flattrClient setOAuthKey:kOAuthKey secret:kOAuthSecret];
    }
    
    [self.flattrClient loginWithCompletionHandler:NULL scope:VUFlattrScope_Flattr];
}

-(void)presentError:(NSError*)error {
    NSString* msg = [NSString stringWithFormat:NSLocalizedString(@"Flattr error: %@", @""), error.localizedDescription];
    UIAlertView* errorView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"") message:msg delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
    [errorView show];
    
    [self activityDidFinish:NO];
}

#pragma mark - VUFlattrAuthHandler methods

-(void)didFailFlattrAuthenticationWithError:(NSError *)error {
}

-(void)didPerformFlattrAuthenticationWithUser:(VUFlattrUser *)user {
    [user thingForURL:self.url completionHandler:^(id data, NSError *error) {
        if (!data) {
            [self presentError:error];
            return;
        }
        
        [self activityDidFinish:YES];
    }];
}

-(void)performFlattrAuthenticationWithPreparedURL:(NSURL *)preparedURL redirectURL:(NSURL *)redirectURL {
    self.authViewController = [[VUAuthViewController alloc] init];
    self.authViewController.delegate = self.flattrClient;
    self.authViewController.redirectURL = redirectURL;
    [self.authViewController openURL:preparedURL];
}

@end
