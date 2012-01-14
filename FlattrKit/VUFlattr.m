//
//  VUFlattr.m
//  FlattrKit
//
//  Created by Boris Bügling on 14.01.12.
//  Copyright (c) 2012 Crocodil.us. All rights reserved.
//

#import "NXOAuth2.h"
#import "VUFlattr.h"
#import "VUFlattrUser.h"

static NSString* const kFlattrServiceType = @"Flattr";
static NSString* const kRedirectURL = @"http://call.back";

@implementation VUFlattr

+(id)flattr {
    return [[self alloc] init];
}

-(NXOAuth2Account*)getAccount {
    NSArray* accounts = [[NXOAuth2AccountStore sharedStore] accounts];
    if (accounts.count != 1) {
        return nil;
    }
    return [accounts objectAtIndex:0];
}

-(void)handleURL:(NSURL *)url {
    [[NXOAuth2AccountStore sharedStore] handleRedirectURL:url];
}

-(void)loginWithCompletionHandler:(VUFlattrLoginCompletionHandler)completionHandler {
    NXOAuth2Account* account = [self getAccount];
    
    if (account) {
        VUFlattrUser* user = [[VUFlattrUser alloc] initWithAccount:account dictionary:nil];
        completionHandler(user, nil);
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreAccountsDidChangeNotification
                                                      object:[NXOAuth2AccountStore sharedStore]
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *aNotification) {
                                                      VUFlattrUser* user = [[VUFlattrUser alloc] initWithAccount:[self getAccount] 
                                                                                                      dictionary:nil];
                                                      completionHandler(user, nil);
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreAccountsDidChangeNotification
                                                      object:[NXOAuth2AccountStore sharedStore]
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *aNotification) {
                                                      NSError *error = [aNotification.userInfo objectForKey:NXOAuth2AccountStoreErrorKey];
                                                      completionHandler(nil, error);
                                                  }];
    
    UIViewController* rootVC = [[UIApplication sharedApplication] keyWindow].rootViewController;
    
    [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:kFlattrServiceType
                                   withPreparedAuthorizationURLHandler:^(NSURL *preparedURL) {
                                       VUAuthViewController* authVC = [[VUAuthViewController alloc] init];
                                       authVC.delegate = self;
                                       authVC.redirectURL = [NSURL URLWithString:kRedirectURL];
                                       [rootVC presentModalViewController:authVC animated:YES];
                                       [authVC openURL:preparedURL];
                                   }];
}

-(void)setOAuthKey:(NSString*)key secret:(NSString*)secret {
    [[NXOAuth2AccountStore sharedStore] setClientID:key
                                             secret:secret
                                   authorizationURL:[NSURL URLWithString:@"https://flattr.com/oauth/authorize"]
                                           tokenURL:[NSURL URLWithString:@"https://flattr.com/oauth/token"]
                                        redirectURL:[NSURL URLWithString:kRedirectURL]
                                     forAccountType:kFlattrServiceType];

}

@end
