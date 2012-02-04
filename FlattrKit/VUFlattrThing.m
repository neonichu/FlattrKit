//
//  VUFlattrThing.m
//  FlattrKit
//
//  Created by Boris Bügling on 14.01.12.
//  Copyright (c) 2012 Crocodil.us. All rights reserved.
//

#import "VUFlattrThing.h"

@interface VUFlattrThing ()

@property (nonatomic, strong) NSString* category;
@property (nonatomic, strong) NSDate* creationDate;
@property (nonatomic, strong) NSString* description;
@property (nonatomic, assign) BOOL hidden;
@property (nonatomic, assign) NSUInteger identifier;
@property (nonatomic, strong) NSString* language;
@property (nonatomic, strong) NSURL* link;
@property (nonatomic, assign) NSUInteger numberOfFlattrs;
@property (nonatomic, strong) NSURL* resource;
@property (nonatomic, strong) NSMutableArray* tags;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSURL* url;
@property (nonatomic, strong) VUFlattrUser* user;

@end

#pragma mark -

@implementation VUFlattrThing

@synthesize category;
@synthesize creationDate;
@synthesize description;
@synthesize hidden;
@synthesize identifier;
@synthesize language;
@synthesize link;
@synthesize numberOfFlattrs;
@synthesize resource;
@synthesize tags;
@synthesize title;
@synthesize url;
@synthesize user;

#pragma mark -

-(id)initWithAccount:(NXOAuth2Account *)account dictionary:(NSDictionary *)dictionary {
    self = [super initWithAccount:account dictionary:dictionary];
    if (self) {
        self.category = [dictionary valueForKey:@"category"];
        self.creationDate = [NSDate dateWithTimeIntervalSince1970:[[dictionary valueForKey:@"created_at"] intValue]];
        self.description = [dictionary valueForKey:@"description"];
        self.hidden = [[dictionary valueForKey:@"hidden"] boolValue];
        self.identifier = [[dictionary valueForKey:@"id"] intValue];
        self.language = [dictionary valueForKey:@"language"];
        self.link = [NSURL URLWithString:[dictionary valueForKey:@"link"]];
        self.numberOfFlattrs = [[dictionary valueForKey:@"flattrs"] intValue];
        self.resource = [NSURL URLWithString:[dictionary valueForKey:@"resource"]];
        self.title = [dictionary valueForKey:@"title"];
        self.url = [NSURL URLWithString:[dictionary valueForKey:@"url"]];
        
        self.tags = [NSMutableArray array];
        for (NSString* tag in [dictionary valueForKey:@"tags"]) {
            [self.tags addObject:tag];
        }
    }
    return self;
}

-(void)flattrThisWithCompletionHandler:(VUFlattrCompletionHandler)completionHandler {
    NSString* urlString = [NSString stringWithFormat:@"https://api.flattr.com/rest/v2/things/%d/flattr", self.identifier];
    [self performMethod:@"POST" onResource:[NSURL URLWithString:urlString] usingParameters:nil completionHandler:^(id data, NSError *error) {
        if (!data) {
            completionHandler(nil, error);
            return;
        }
        
        if (![[data objectForKey:@"message"] isEqualToString:@"ok"]) {
            NSString* message = [data objectForKey:@"error_description"];
            if (!message) {
                message = [data objectForKey:@"description"];
                if (!message) {
                    message = [NSString stringWithFormat:@"Unknown error, full response: %@", data];
                }
            }
            
            completionHandler(nil, [[self class] errorWithDescription:message]);
            return;
        }
        
        completionHandler(self, nil);
    }];
}

@end
