//
//  VUFlattr.h
//  FlattrKit
//
//  Created by Boris Bügling on 14.01.12.
//  Copyright (c) 2012 Crocodil.us. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VUAuthViewController.h"

@class VUFlattrUser;

typedef enum {
    VUFlattrScope_Default,          // Default - like without specfiying a scope
    VUFlattrScope_Flattr,           // Flattr things
    VUFlattrScope_Thing,            // Create, update and delete things
    VUFlattrScope_ExtendedRead,     // Read private user attributes and find hidden things
} VUFlattrScope;

typedef void (^VUFlattrLoginCompletionHandler)(VUFlattrUser* user, NSError* error);

@interface VUFlattr : NSObject <VUAuthRedirectDelegate>

+(id)flattr;

-(void)loginWithCompletionHandler:(VUFlattrLoginCompletionHandler)completionHandler;
-(void)loginWithCompletionHandler:(VUFlattrLoginCompletionHandler)completionHandler scope:(VUFlattrScope)scope;
-(void)setOAuthKey:(NSString*)key secret:(NSString*)secret;

@end
