//
//  VUFlattrElement.m
//  FlattrKit
//
//  Created by Boris Bügling on 14.01.12.
//  Copyright (c) 2012 Crocodil.us. All rights reserved.
//

#import "NXOAuth2Request+Bearer.h"
#import "VUFlattrElement.h"

@interface VUFlattrElement ()

@property (nonatomic, strong) NXOAuth2Account* account;

@end

#pragma mark -

@implementation VUFlattrElement

@synthesize account;

#pragma mark -

+(NSError*)errorWithDescription:(NSString*)description {
    NSDictionary* dict = [NSDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey];
    return [NSError errorWithDomain:@"vu.org.flattrkit" code:0 userInfo:dict];
}

#pragma mark -

-(id)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

-(id)initWithAccount:(NXOAuth2Account *)anAccount dictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.account = anAccount;
    }
    return self;
}

-(id)initWithElement:(VUFlattrElement*)element dictionary:(NSDictionary*)dictionary {
    self = [self initWithAccount:element.account dictionary:dictionary];
    return self;
}

-(void)performMethod:(NSString*)method onResource:(NSURL*)resource usingParameters:(NSDictionary*)parameters 
   completionHandler:(VUFlattrCompletionHandler)completionHandler {
    [NXOAuth2Request vu_performMethod:method onResource:resource 
                      usingParameters:parameters withAccount:self.account 
                      responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error) {
                          int statusCode = response ? 200 : 500;
                          if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                              statusCode = ((NSHTTPURLResponse*)response).statusCode;
                          }
                          
                          if (!responseData || statusCode < 200 || statusCode >= 400) {
                              if (!error) {
                                  id errorData = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
                                  if (errorData) {
                                      NSString* description = [errorData valueForKey:@"error_description"];
                                      if (description) {
                                          completionHandler(nil, [[self class] errorWithDescription:description]);
                                          return;
                                      }
                                  }
                                  
                                  NSLog(@"Empty error, response data: %@", [[NSString alloc] initWithData:responseData 
                                                                                                 encoding:NSUTF8StringEncoding]);
                              }
                              completionHandler(nil, error);
                              return;
                          }
                          
                          id data = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
                          if (!data) {
                              completionHandler(nil, error);
                              return;
                          }
                          
                          completionHandler(data, nil);
                      }];
}

@end
