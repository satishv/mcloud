//
//  collectivlySingleton.h
//  collectivly
//
//  Created by Nathan Fraenkel on 4/6/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface collectivlySingleton : NSObject {
    NSMutableArray *personalStories, *popularCollections;
    NSMutableDictionary *storiesForCollectionWithId;
    
    BOOL isLoggedIn;
}

@property (nonatomic, readwrite) BOOL isLoggedIn;
@property (nonatomic, readwrite) NSInteger currentCollectionId;
@property (nonatomic, retain) NSMutableArray *personalStories, *popularCollections;
@property (nonatomic, retain) NSMutableDictionary *storiesForCollectionWithId;

@property (nonatomic, retain) NSString *authToken;

+ (collectivlySingleton *) sharedDataModel;


@end
