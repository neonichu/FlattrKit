//
//  VUFlattrUser.m
//  FlattrKit
//
//  Created by Boris Bügling on 14.01.12.
//  Copyright (c) 2012 Crocodil.us. All rights reserved.
//

#import "VUFlattrThing.h"
#import "VUFlattrUser.h"

@implementation VUFlattrUser

#pragma mark -

-(void)thingsWithCompletionHandler:(VUFlattrCompletionHandler)completionHandler; {
    [self performMethod:@"GET" onResource:[NSURL URLWithString:@"https://api.flattr.com/rest/v2/user/things"]  usingParameters:nil 
      completionHandler:^(id data, NSError *error) {
          if (!data) {
              completionHandler(nil, error);
              return;
          }
          
          NSMutableArray* things = [NSMutableArray array];
          for (NSDictionary* dict in data) {
              [things addObject:[[VUFlattrThing alloc] initWithElement:self dictionary:dict]];
          }
          completionHandler(things, nil);
      }];
}

@end
