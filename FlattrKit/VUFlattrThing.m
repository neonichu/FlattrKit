//
//  VUFlattrThing.m
//  FlattrKit
//
//  Created by Boris Bügling on 14.01.12.
//  Copyright (c) 2012 Crocodil.us. All rights reserved.
//

#import "VUFlattrThing.h"

@interface VUFlattrThing ()

@property (nonatomic, strong) NSString* description;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) VUFlattrUser* user;

@end

#pragma mark -

@implementation VUFlattrThing

@synthesize description;
@synthesize title;
@synthesize user;

#pragma mark -

-(id)initWithAccount:(NXOAuth2Account *)account dictionary:(NSDictionary *)dictionary {
    self = [super initWithAccount:account dictionary:dictionary];
    if (self) {
        self.description = [dictionary valueForKey:@"description"];
        self.title = [dictionary valueForKey:@"title"];
    }
    return self;
}

/*
 JSON for thing:
 
 {
 "type": "thing",
 "resource": "https://api.flattr.com/rest/v2/things/423405",
 "link": "https://flattr.com/thing/423405",
 "id": 423405,
 "url": "http://blog.flattr.net/2011/10/api-v2-beta-out-whats-changed/",
 "language": "en_GB",
 "category": "text",
 "owner": {
 "type": "user",
 "resource": "https://api.flattr.com/rest/v2/users/flattr",
 "link": "https://flattr.com/profile/flattr",
 "username": "flattr"
 },
 "hidden": false,
 "created_at": 1319704532,
 "tags": [
 "api"
 ],
 "flattrs": 8,
 "description": "We have been working hard to deliver a great experience for developers and tried to build a good foundation for easily add new features. The API will remain in beta for a while for us to kill quirks and refine some of the resources, this means there might be big changes without notice for ...",
 "title": "API v2 beta out - what's changed?"
 }
 
*/

@end
