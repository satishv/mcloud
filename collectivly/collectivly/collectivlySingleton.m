//
//  collectivlySingleton.m
//  collectivly
//
//  Created by Nathan Fraenkel on 4/6/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import "collectivlySingleton.h"

@implementation collectivlySingleton

@synthesize stories, isLoggedIn, authToken, collections;

static collectivlySingleton *sharedDataModel = nil;

+ (collectivlySingleton *) sharedDataModel {
    @synchronized(self){
        if (sharedDataModel == nil){
            sharedDataModel = [[collectivlySingleton alloc] init];
        }
    }
    return sharedDataModel;
}

@end
