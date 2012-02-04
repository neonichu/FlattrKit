//
//  VUFlattrUser.m
//  FlattrKit
//
//  Created by Boris Bügling on 14.01.12.
//  Copyright (c) 2012 Crocodil.us. All rights reserved.
//

#import "VUFlattrThing.h"
#import "VUFlattrUser.h"

@interface VUFlattrUser () 

@property (nonatomic, strong) NSString* username;

@end

#pragma mark -

@implementation VUFlattrUser

@synthesize username;

#pragma mark -

-(void)autosubmitURL:(NSURL*)url withErrorHandler:(VUFlattrErrorHandler)errorHandler {
    [self fetchInfoWithCompletionHandler:^(id data, NSError *error) {
        if (!data) {
            errorHandler(error);
            return;
        }
        
        NSString* autoSubmit = [NSString stringWithFormat:@"https://flattr.com/submit/auto?user_id=%@&url=%@", self.username, 
                                [url.absoluteString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [self performMethod:@"GET" onResource:[NSURL URLWithString:autoSubmit] usingParameters:nil completionHandler:^(id data, NSError *error) {
            if (!data) {
                errorHandler(error);
                return;
            }
            
            NSLog(@"Auto-submit result: %@", data);
        }];
    }];
}
                            
-(void)fetchInfoWithCompletionHandler:(VUFlattrCompletionHandler)completionHandler {
    if (self.username) {
        completionHandler(self, nil);
    }
    
    [self performMethod:@"GET" onResource:[NSURL URLWithString:@"https://api.flattr.com/rest/v2/user"] usingParameters:nil 
      completionHandler:^(id data, NSError *error) {
          if (!data) {
              completionHandler(nil, error);
              return;
          }
          
          self.username = [data objectForKey:@"username"];
          completionHandler(self, nil);
      }];
}

-(void)flattrURL:(NSURL*)url withCompletionHandler:(VUFlattrCompletionHandler)completionHandler {
    NSError* error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithObject:[url absoluteString] forKey:@"url"] 
                                                       options:0 error:&error];
    if (!jsonData) {
        completionHandler(nil, error);
        return;
    }
    
    NSDictionary* params = [NSDictionary dictionaryWithObject:jsonData forKey:@"postData"];
    [self performMethod:@"POST" onResource:[NSURL URLWithString:@"https://api.flattr.com/rest/v2/flattr"] usingParameters:params 
      completionHandler:^(id data, NSError *error) {
          if (!data) {
              completionHandler(nil, error);
              return;
          }
          
          NSLog(@"Flattered URL: %@", data);
    }];
}

-(void)thingsWithCompletionHandler:(VUFlattrCompletionHandler)completionHandler {
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

-(void)thingForSearchTerm:(NSString*)term completionHandler:(VUFlattrCompletionHandler)completionHandler {
    NSString* urlString = [NSString stringWithFormat:@"https://api.flattr.com/rest/v2/things/search?query=%@", 
                           [term stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [self performMethod:@"GET" onResource:[NSURL URLWithString:urlString] usingParameters:nil completionHandler:^(id data, NSError *error) {
        if (!data) {
            completionHandler(nil, error);
            return;
        }
        
        NSArray* thingDicts = [data valueForKey:@"things"];
        if (!thingDicts) {
            completionHandler(nil, [[self class] errorWithDescription:@"No matching thing found."]);
            return;
        }
        
        NSMutableArray* things = [NSMutableArray array];
        for (NSDictionary* dict in thingDicts) {
            [things addObject:[[VUFlattrThing alloc] initWithElement:self dictionary:dict]];
        }
        completionHandler(things, nil);
    }];
}

-(void)thingForURL:(NSURL*)url completionHandler:(VUFlattrCompletionHandler)completionHandler {
    NSString* urlString = [NSString stringWithFormat:@"https://api.flattr.com/rest/v2/things/lookup/?url=%@", 
                           [[url absoluteString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [self performMethod:@"GET" onResource:[NSURL URLWithString:urlString]  usingParameters:nil 
      completionHandler:^(id data, NSError *error) {
          if (!data) {
              completionHandler(nil, error);
              return;
          }
          
          NSString* type = [data valueForKey:@"type"];
          if ([type isEqualToString:@"thing"]) {
              VUFlattrThing* thing = [[VUFlattrThing alloc] initWithElement:self dictionary:data];
              completionHandler(thing, nil);
              return;
          }
          
          NSString* location = [data valueForKey:@"location"];
          if (!location) {
              completionHandler(nil, [[self class] errorWithDescription:@"Thing not found."]);
              return;
          }
          
          [self performMethod:@"GET" onResource:[NSURL URLWithString:location] usingParameters:nil 
            completionHandler:^(id data, NSError *error) {
                if (!data) {
                    completionHandler(nil, error);
                    return;
                }
                
                VUFlattrThing* thing = [[VUFlattrThing alloc] initWithElement:self dictionary:data];
                completionHandler(thing, nil);
          }];
      }];
}

@end
