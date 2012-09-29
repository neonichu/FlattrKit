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

// For debugging
#define REMOVE_ACCOUNTS     0

static NSString* const kAuthURL = @"https://flattr.com/oauth/authorize";
static NSString* const kFlattrServiceType = @"Flattr";
static NSString* const kRedirectURL = @"http://call.back";
static NSString* const kTokenURL = @"https://flattr.com/oauth/token";

@interface VUFlattr () <VUFlattrAuthHandler>

@end

#pragma mark -

@implementation VUFlattr

@synthesize authHandler = _authHandler;

#pragma mark -

+(id)flattr {
#if REMOVE_ACCOUNTS
    for (NXOAuth2Account* account in [[NXOAuth2AccountStore sharedStore] accounts]) {
        [[NXOAuth2AccountStore sharedStore] removeAccount:account];
    }
#endif
    return [[self alloc] init];
}

+(NSString*)stringForScope:(VUFlattrScope)scope {
    switch (scope) {
        case VUFlattrScope_Flattr:
            return @"flattr";
        case VUFlattrScope_Thing:
            return @"thing";
        case VUFlattrScope_ExtendedRead:
            return @"extendedread";
        default:
            break;
    }
    
    [NSException raise:@"Flattr Error" format:@"Scope %d is not supported.", scope];
    return nil;
}

#pragma mark -

-(void)dealloc {
    NXOAuth2AccountStore* store = [NXOAuth2AccountStore sharedStore];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NXOAuth2AccountStoreAccountsDidChangeNotification object:store];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NXOAuth2AccountStoreDidFailToRequestAccessNotification object:store];
}

-(NXOAuth2Account*)getAccount {
    NSArray* accounts = [[NXOAuth2AccountStore sharedStore] accounts];
    if (accounts.count < 1) {
        return nil;
    }
    return [accounts objectAtIndex:0];
}

-(void)handleURL:(NSURL *)url {
    [[NXOAuth2AccountStore sharedStore] handleRedirectURL:url];
}

-(id)init {
    self = [super init];
    if (self) {
        self.authHandler = self;
    }
    return self;
}

-(void)loginWithCompletionHandler:(VUFlattrLoginCompletionHandler)completionHandler {
    [self loginWithCompletionHandler:completionHandler scope:VUFlattrScope_Default];
}

-(void)loginWithCompletionHandler:(VUFlattrLoginCompletionHandler)completionHandler scope:(VUFlattrScope)scope {
    NXOAuth2Account* account = [self getAccount];
    
    if (account) {
        VUFlattrUser* user = [[VUFlattrUser alloc] initWithAccount:account dictionary:nil];
        if (completionHandler) {
            completionHandler(user, nil);
        }
        return;
    }
    
    if (scope != VUFlattrScope_Default) {
        NSString* scopeAsString = [[self class] stringForScope:scope];
        NSMutableDictionary* configuration = [[[NXOAuth2AccountStore sharedStore] configurationForAccountType:kFlattrServiceType] mutableCopy];
        [configuration setValue:[NSDictionary dictionaryWithObject:scopeAsString forKey:@"scope"] 
                         forKey:kNXOAuth2AccountStoreConfigurationParameters];
        [[NXOAuth2AccountStore sharedStore] setConfiguration:configuration forAccountType:kFlattrServiceType];
    }
    
#if TARGET_OS_IPHONE
    [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreAccountsDidChangeNotification
                                                      object:[NXOAuth2AccountStore sharedStore]
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *aNotification) {
                                                      VUFlattrUser* user = [[VUFlattrUser alloc] initWithAccount:[self getAccount] 
                                                                                                      dictionary:nil];
                                                      
                                                      if ([self.authHandler
                                                           respondsToSelector:@selector(didPerformFlattrAuthenticationWithUser:)] ) {
                                                          [self.authHandler didPerformFlattrAuthenticationWithUser:user];
                                                      }
                                                      
                                                      if (completionHandler) {
                                                          completionHandler(user, nil);
                                                      }
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreDidFailToRequestAccessNotification
                                                      object:[NXOAuth2AccountStore sharedStore]
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *aNotification) {
                                                      NSError *error = [aNotification.userInfo objectForKey:NXOAuth2AccountStoreErrorKey];
                                                      
                                                      if ([self.authHandler
                                                           respondsToSelector:@selector(didFailFlattrAuthenticationWithError:)]) {
                                                          [self.authHandler didFailFlattrAuthenticationWithError:error];
                                                      }
                                                      
                                                      if (completionHandler) {
                                                          completionHandler(nil, error);
                                                      }
                                                  }];
    
    [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:kFlattrServiceType
                                   withPreparedAuthorizationURLHandler:^(NSURL *preparedURL) {
                                       if ([self.authHandler
                                            respondsToSelector:@selector(performFlattrAuthenticationWithPreparedURL:redirectURL:)]) {
                                           [self.authHandler performFlattrAuthenticationWithPreparedURL:preparedURL
                                                                                            redirectURL:[NSURL URLWithString:kRedirectURL]];
                                       }
                                   }];
#endif
}

-(void)setOAuthKey:(NSString*)key secret:(NSString*)secret {
    [[NXOAuth2AccountStore sharedStore] setClientID:key
                                             secret:secret
                                   authorizationURL:[NSURL URLWithString:kAuthURL]
                                           tokenURL:[NSURL URLWithString:kTokenURL]
                                        redirectURL:[NSURL URLWithString:kRedirectURL]
                                     forAccountType:kFlattrServiceType];
}

#pragma mark - VUFlattrAuthHandler methods

-(void)didFailFlattrAuthenticationWithError:(NSError *)error {
    UIViewController* rootVC = [[UIApplication sharedApplication] keyWindow].rootViewController;
    [rootVC dismissModalViewControllerAnimated:YES];
}

-(void)didPerformFlattrAuthenticationWithUser:(VUFlattrUser *)user {
    UIViewController* rootVC = [[UIApplication sharedApplication] keyWindow].rootViewController;
    [rootVC dismissModalViewControllerAnimated:YES];
}

-(void)performFlattrAuthenticationWithPreparedURL:(NSURL *)preparedURL redirectURL:(NSURL *)redirectURL {
    UIViewController* rootVC = [[UIApplication sharedApplication] keyWindow].rootViewController;
    VUAuthViewController* authVC = [[VUAuthViewController alloc] init];
    authVC.delegate = self;
    authVC.redirectURL = redirectURL;
    [rootVC presentModalViewController:authVC animated:YES];
    [authVC openURL:preparedURL];
}

@end
