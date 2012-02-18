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

/**
 A thing is an object that can be flattrd.
 
 http://developers.flattr.net/api/resources/things/
 */
@interface VUFlattrThing : VUFlattrElement

/**
 Retrieve the description of the receiver.
 
 @return Description of the receiver.
 */
-(NSString*)description;

/**
 Retrieve the Flattr thing URL of the receiver.
 
 @return Flattr thing URL of the receiver.
 */
-(NSURL*)flattrUrl;

/**
 Retrieve the identifier of the receiver.
 
 @return Identifier of the receiver.
 */
-(NSUInteger)identifier;

/**
 Retrieve the title of the receiver.
 
 @return Title of the receiver.
 */
-(NSString*)title;

/**
 Retrieve the actual source URL of the receiver.
 
 @return Actual source URL of the receiver.
 */
-(NSURL*)url;

/**
 Retrieve the user object used to retrieve the receiver via the API. It is not the user who owns the thing.
 
 @return The user object used to retrieve this thing.
 */
-(VUFlattrUser*)user;

/**
 Flattr this thing.
 
 @param completionHandler This is called after trying to flattr this thing. Error status needs to be checked in that handler.
 */
-(void)flattrThisWithCompletionHandler:(VUFlattrCompletionHandler)completionHandler;

@end
