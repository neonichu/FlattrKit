//
//  VUFlattrElement.h
//  FlattrKit
//
//  Created by Boris Bügling on 14.01.12.
//  Copyright (c) 2012 Crocodil.us. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NXOAuth2.h"

typedef void (^VUFlattrCompletionHandler)(id data, NSError* error);

@interface VUFlattrElement : NSObject

-(id)initWithAccount:(NXOAuth2Account*)account dictionary:(NSDictionary*)dictionary;
-(id)initWithElement:(VUFlattrElement*)element dictionary:(NSDictionary*)dictionary;

-(void)performMethod:(NSString*)method onResource:(NSURL*)resource usingParameters:(NSDictionary*)parameters 
   completionHandler:(VUFlattrCompletionHandler)completionHandler;

@end
