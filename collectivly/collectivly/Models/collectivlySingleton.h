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

@interface collectivlySingleton : NSObject 

@property (nonatomic, strong) collectivlyCollection *currentCollection;
@property (nonatomic, strong) NSMutableDictionary *storiesForCollectionWithId;
@property (nonatomic, strong) NSArray *stories, *collections;
@property (nonatomic, strong) collectivlyStory *currentStory;
@property (nonatomic, strong) NSString *authToken, *email;

+ (collectivlySingleton *) sharedDataModel;

-(BOOL)isLoggedIn;


@end
