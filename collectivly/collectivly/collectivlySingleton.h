//
//  collectivlySingleton.h
//  collectivly
//
//  Created by Nathan Fraenkel on 4/6/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "collectivlyCollection.h"
#import "collectivlyStory.h"

@interface collectivlySingleton : NSObject {
    NSMutableArray *personalStories, *popularCollections;
    NSMutableDictionary *storiesForCollectionWithId;
    
    BOOL isLoggedIn;
}

@property (nonatomic, readwrite) BOOL isLoggedIn;
@property (nonatomic, readwrite) collectivlyCollection *currentCollection;
@property (nonatomic, retain) NSMutableArray *personalStories, *collections;
@property (nonatomic, retain) NSMutableDictionary *storiesForCollectionWithId;
@property (nonatomic, retain) NSArray *currentStories;
@property (nonatomic, retain) collectivlyStory *currentStory;

@property (nonatomic, retain) NSString *authToken;

+ (collectivlySingleton *) sharedDataModel;


@end
