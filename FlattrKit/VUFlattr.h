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

typedef void (^VUFlattrLoginCompletionHandler)(VUFlattrUser* user, NSError* error);

@interface VUFlattr : NSObject <VUAuthRedirectDelegate>

+(id)flattr;

-(void)loginWithCompletionHandler:(VUFlattrLoginCompletionHandler)completionHandler;
-(void)setOAuthKey:(NSString*)key secret:(NSString*)secret;

@end
