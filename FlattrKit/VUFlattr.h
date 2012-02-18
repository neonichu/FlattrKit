//
//  VUFlattr.h
//  FlattrKit
//
//  Created by Boris Bügling on 14.01.12.
//  Copyright (c) 2012 Crocodil.us. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#import "VUAuthViewController.h"
#endif

@class VUFlattrUser;

typedef enum {
    VUFlattrScope_Default,          // Default - like without specfiying a scope
    VUFlattrScope_Flattr,           // Flattr things
    VUFlattrScope_Thing,            // Create, update and delete things
    VUFlattrScope_ExtendedRead,     // Read private user attributes and find hidden things
} VUFlattrScope;

typedef void (^VUFlattrLoginCompletionHandler)(VUFlattrUser* user, NSError* error);

/** 
 Connect to Flattr using the REST v2 API.
 
 Most calls are asynchronous because they require network access. FlattrKit makes heavy use of blocks and is only compatible with iOS 5.
 
 http://developers.flattr.net/api/
 */

#if TARGET_OS_IPHONE
@interface VUFlattr : NSObject <VUAuthRedirectDelegate>
#else
@interface VUFlattr : NSObject
#endif

/** Retrieve singleton instance. */
+(id)flattr;

/** Login 
 
 @param completionHandler The completion handler is called when the login is finished. Depending on the success you will receive the logged in
 user object or an error.
 */
-(void)loginWithCompletionHandler:(VUFlattrLoginCompletionHandler)completionHandler;

/** Login 
 
 @param completionHandler The completion handler is called when the login is finished. Depending on the success you will receive the logged in
 user object or an error.
 @param scope The scope controls which actions your application can perform using the API. By default, you will only have read access. You may
 request the ability to flattr things, perform operations on your own things or read private data and hidden things of a user.
 */
-(void)loginWithCompletionHandler:(VUFlattrLoginCompletionHandler)completionHandler scope:(VUFlattrScope)scope;

/**
 Set the OAuth key and secret for your application.
 
 You need to register your application with Flattr to receive them: http://flattr.com/apps
 
 @param key OAuth key
 @param secret OAuth secret
 */
-(void)setOAuthKey:(NSString*)key secret:(NSString*)secret;

@end
