//
//  GetStoriesForCollectionCommand.h
//  collectivly
//
//  Created by Nathan Fraenkel on 7/20/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "collectivlyStory.h"

@class collectivlyCollection;

@protocol GetStoriesDelegate <NSObject>
-(void)reactToGetStoriesResponse:(NSArray*)newStories;
-(void)reactToGetStoriesError:(NSError*)error;
@end

@interface GetStoriesForCollectionCommand : NSObject <NSURLConnectionDataDelegate> {
    NSArray *storiesFromResponse;
    NSMutableData *_data;
}

@property (nonatomic, strong) collectivlyCollection *collection;
@property (nonatomic, strong) id<GetStoriesDelegate> delegate;
@property (nonatomic, assign) NSInteger page;

-(id)initWithCollection:(collectivlyCollection*)coll andPageNumber:(NSInteger)pNum;
-(void)fetchStoriesForCollectionFromPage;

@end
