//
//  VotingCommand.h
//  collectivly
//
//  Created by Nathan Fraenkel on 7/21/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class collectivlyStory;

@protocol VotingRequestDelegate <NSObject>
-(void)successfulUpvote;
-(void)successfulUpvoteUnclick;
-(void)successfulDownvote;
-(void)successfulDownvoteUnclick;
-(void)errorOccuredDuringVote:(NSError*)error;
@end

@interface VotingCommand : NSObject <NSURLConnectionDataDelegate> {
    NSMutableData *_data;
}

@property (nonatomic, strong) NSString *value, *type, *tokenOfAuth;
@property (nonatomic, strong) collectivlyStory *story;
@property (nonatomic, strong) id<VotingRequestDelegate> delegate;

-(id)initWithStory:(collectivlyStory*)s andToken:(NSString*)auth;
-(void)makeUpvoteRequest;
-(void)makeDownvoteRequest;
-(void)makeUpvoteUnclickRequest;
-(void)makeDownvoteUnclickRequest;

@end
