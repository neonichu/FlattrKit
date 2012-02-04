//
//  VUFlattrUser.h
//  FlattrKit
//
//  Created by Boris Bügling on 14.01.12.
//  Copyright (c) 2012 Crocodil.us. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VUFlattrElement.h"

@interface VUFlattrUser : VUFlattrElement

-(void)thingsWithCompletionHandler:(VUFlattrCompletionHandler)completionHandler;
-(void)thingForSearchTerm:(NSString*)term completionHandler:(VUFlattrCompletionHandler)completionHandler;
-(void)thingForURL:(NSURL*)url completionHandler:(VUFlattrCompletionHandler)completionHandler;

@end
