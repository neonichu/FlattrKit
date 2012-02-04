//
//  VUAppDelegate.m
//  FlattrKit
//
//  Created by Boris Bügling on 14.01.12.
//  Copyright (c) 2012 Crocodil.us. All rights reserved.
//

#import "VUAppDelegate.h"
#import "VUViewController.h"

#import "FlattrKit.h"

@implementation VUAppDelegate

@synthesize flattrClient;
@synthesize window;

-(void)alertForError:(NSError*)error {
    NSString* msg = [NSString stringWithFormat:@"Flattr error: %@", error.localizedDescription];
    UIAlertView* errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:nil 
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorView show];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[VUViewController alloc] init];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self performSelector:@selector(loginToFlattr) withObject:nil afterDelay:0.5];
    
    return YES;
}

- (void)handleThing:(VUFlattrThing*)thing {
    NSLog(@"Thing found: %@", thing);
    
    [thing flattrThisWithCompletionHandler:^(id data, NSError *error) {
        if (!data) {
            [self alertForError:error];
            return;
        }
        
        NSLog(@"Flattred a thing: %@", data);
    }];
}

- (void)lookUpThingWithUrl:(NSURL*)url user:(VUFlattrUser*)user {
    [user thingForURL:url completionHandler:^(id data, NSError *error) {
        if (!data) {
            [user thingForSearchTerm:[url absoluteString] completionHandler:^(id data, NSError *error) {
                if (!data) {
                    [self alertForError:error];
                    return;
                }
                
                NSAssert([data count] > 0, @"Flattr search returned empty result.");
                data = [data objectAtIndex:0];
                
                [self handleThing:data];
            }];
            return;
        }
        
        [self handleThing:data];
    }];
}

- (void)loginToFlattr {
    self.flattrClient = [VUFlattr flattr];
    
    [self.flattrClient setOAuthKey:@"G8LwBUlkvxqhkpmP7U25IBp2loGTsBvYz6k1QwccTsk4IwJGhCCQ4RIf5eYoFjc5" 
                            secret:@"gnXWJZZti9nQvXmDqOjkwSpsWeGsoJouWchw27Qa64QsR3V8I5i4NynADTSRt7cg"];
    
    [self.flattrClient loginWithCompletionHandler:^(VUFlattrUser* user, NSError *error) {
        if (!user) {
            [self alertForError:error];
            return;
        }
        
        [user thingsWithCompletionHandler:^(id data, NSError *error) {
            if (!data) {
                [self alertForError:error];
                return;
            }
            NSLog(@"Things for user: %@", data);
        }];
        
        NSURL* bamRealURL = [NSURL URLWithString:@"http://breakfast.vu0.org/"];
        //NSURL* bamFlattrURL = [NSURL URLWithString:@"http://manuspielt.wordpress.com/2010/11/26/breakfast-at-manuspielts/"];
        
        [self lookUpThingWithUrl:bamRealURL user:user];
        //[self lookUpThingWithUrl:bamFlattrURL user:user];
        
        //[user autosubmitURL:bamFlattrURL];
    } scope:VUFlattrScope_Flattr];
}

@end
