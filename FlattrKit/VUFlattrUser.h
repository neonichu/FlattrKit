//
//  VUFlattrUser.h
//  FlattrKit
//
//  Created by Boris Bügling on 14.01.12.
//  Copyright (c) 2012 Crocodil.us. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VUFlattrElement.h"

/**
 A user of Flattr.
 
 http://developers.flattr.net/api/resources/users/
 */
@interface VUFlattrUser : VUFlattrElement

/**
 Try to autosubmit the given URL with this user.
 
 http://developers.flattr.net/auto-submit/
 
 @param url The URL to autosubmit.
 @param errorHandler The error handler is called if an error occurs.
 */
-(void)autosubmitURL:(NSURL*)url withErrorHandler:(VUFlattrErrorHandler)errorHandler;

/**
 Retrieve the information for this user asynchronously.
 
 @param completionHandler The completion handler is called when the retrieval is finished.
 */
-(void)fetchInfoWithCompletionHandler:(VUFlattrCompletionHandler)completionHandler;

/**
 Retrieve this user's things asynchronously.
 
 @param completionHandler The completion handler is called when the retrieval is finished.
 */
-(void)thingsWithCompletionHandler:(VUFlattrCompletionHandler)completionHandler;

/**
 Retrieve a list of matching things for a search term.
 
 @param term The term to search for.
 @param completionHandler The completion handler is called when the retrieval is finished.
 */
-(void)thingForSearchTerm:(NSString*)term completionHandler:(VUFlattrCompletionHandler)completionHandler;

/**
 Retrieve the thing for a given URL.
 
 @param url The URL to search for.
 @param completionHandler The completion handler is called when the retrieval is finished.
 */
-(void)thingForURL:(NSURL*)url completionHandler:(VUFlattrCompletionHandler)completionHandler;

@end
