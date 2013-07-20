//
//  GetCollectionsCommand.h
//  collectivly
//
//  Created by Nathan Fraenkel on 7/14/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "collectivlyCollection.h"

@protocol GetCollectionsDelegate <NSObject>
-(void)reactToGetCollectionsResponse:(NSArray*)collections;
-(void)reactToGetCollectionsError:(NSError*)error;
@end

@interface GetCollectionsCommand : NSObject <NSURLConnectionDataDelegate> {
    NSArray *collectionsFromResponse;
    NSMutableData *_data;
}

@property (nonatomic, readwrite) BOOL userIsLoggedIn;
@property (nonatomic, strong) id<GetCollectionsDelegate> delegate;

-(id)initWithUserAlreadyLoggedInBool:(BOOL)booleano;
-(void)fetchCollections;

@end
