//
//  CloudableCurrentLoggedInUser.m
//  cloudable
//
//  Created by Nathan Fraenkel on 3/24/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import "CloudableCurrentLoggedInUser.h"

@implementation CloudableCurrentLoggedInUser

@synthesize stories;

static CloudableCurrentLoggedInUser *sharedDataModel = nil;

+ (CloudableCurrentLoggedInUser *) sharedDataModel {
    @synchronized(self){
        if (sharedDataModel == nil){
            sharedDataModel = [[CloudableCurrentLoggedInUser alloc] init];
        }
    }
    return sharedDataModel;
}

@end
