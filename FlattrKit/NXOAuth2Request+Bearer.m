//
//  NXOAuth2Request+Bearer.m
//  FlattrKit
//
//  Created by Boris Bügling on 14.01.12.
//  Copyright (c) 2012 Crocodil.us. All rights reserved.
//

#import "NXOAuth2Request+Bearer.h"

static NSString* const kHTTPAuthHeaderField = @"Authorization";

@implementation NXOAuth2Request (Bearer)

+ (void)vu_performMethod:(NSString *)method
              onResource:(NSURL *)resource
         usingParameters:(NSDictionary *)parameters
             withAccount:(NXOAuth2Account *)account
         responseHandler:(NXOAuth2ConnectionResponseHandler)responseHandler {
    NXOAuth2Request* oauthRequest = [[NXOAuth2Request alloc] initWithResource:resource method:method parameters:parameters];
    oauthRequest.account = account;
    NSMutableURLRequest* request = (NSMutableURLRequest*)[oauthRequest signedURLRequest];
    
    NSString* auth = [request valueForHTTPHeaderField:kHTTPAuthHeaderField];
    NSArray* components = [auth componentsSeparatedByString:@" "];
    if (components.count == 2) {
        auth = [NSString stringWithFormat:@"Bearer %@", [components lastObject]];
        [request setValue:auth forHTTPHeaderField:kHTTPAuthHeaderField];
    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:responseHandler];
}

@end
