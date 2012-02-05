//
//  VUFlattrThing.h
//  FlattrKit
//
//  Created by Boris Bügling on 14.01.12.
//  Copyright (c) 2012 Crocodil.us. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VUFlattrElement.h"

@class VUFlattrUser;

@interface VUFlattrThing : VUFlattrElement

-(NSString*)description;
-(NSURL*)flattrUrl;
-(NSUInteger)identifier;
-(NSString*)title;
-(NSURL*)url;
-(VUFlattrUser*)user;

-(void)flattrThisWithCompletionHandler:(VUFlattrCompletionHandler)completionHandler;

@end
