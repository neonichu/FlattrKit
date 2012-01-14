//
//  NXOAuth2Request+Bearer.h
//  FlattrKit
//
//  Created by Boris Bügling on 14.01.12.
//  Copyright (c) 2012 Crocodil.us. All rights reserved.
//

#import "NXOAuth2Request.h"

@interface NXOAuth2Request (Bearer)

+ (void)vu_performMethod:(NSString *)method
           onResource:(NSURL *)resource
      usingParameters:(NSDictionary *)parameters
          withAccount:(NXOAuth2Account *)account
      responseHandler:(NXOAuth2ConnectionResponseHandler)responseHandler;

@end
