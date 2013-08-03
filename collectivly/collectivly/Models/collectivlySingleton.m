//
//  collectivlySingleton.m
//  collectivly
//
//  Created by Nathan Fraenkel on 4/6/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import "collectivlySingleton.h"

@implementation collectivlySingleton

@synthesize authToken, stories, collections, storiesForCollectionWithId, currentCollection, currentStory, email, firstName, lastName, profileImage, profileImageUrl;

static collectivlySingleton *sharedDataModel = nil;

+ (collectivlySingleton *) sharedDataModel {
    @synchronized(self){
        if (sharedDataModel == nil){
            sharedDataModel = [[collectivlySingleton alloc] init];
        }
    }
    return sharedDataModel;
}

-(BOOL)isLoggedIn {
    return (self.email && ![self.email isEqualToString:@""] && self.authToken && ![self.authToken isEqualToString:@""]);
}

@end
