//
//  GetStoryInfoCommand.h
//  collectivly
//
//  Created by Nathan Fraenkel on 8/3/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "collectivlyStory.h"

@protocol GetStoryDelegate <NSObject>
-(void)reactToStoryResponse;
-(void)reactToStoryError:(NSError*)error;
@end

@interface GetStoryInfoCommand : NSObject <NSURLConnectionDataDelegate> {
    NSMutableData *_data;
}

@property (nonatomic, strong) collectivlyStory *story;
@property (nonatomic, strong) id<GetStoryDelegate> delegate;

-(id)initWithStory:(collectivlyStory *)st;
-(void)fetchStory;

@end
