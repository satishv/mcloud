//
//  VotingCommand.m
//  collectivly
//
//  Created by Nathan Fraenkel on 7/21/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import "VotingCommand.h"
#import "collectivlyStory.h"

@implementation VotingCommand

@synthesize type, value, tokenOfAuth, story, delegate;

-(id)initWithStory:(collectivlyStory *)s andToken:(NSString *)auth {
    self = [super init];
    if (self) {
        // custom init
        self.story = s;
        self.tokenOfAuth = auth;
    }
    return self;
}

-(void)makeUpvoteRequest {
    NSLog(@"[VotingCommand] UPVOTE CLICK!....");
    [self makeVotingRequestWithClickType:kParametersTypeClick
                          andVotingValue:kParametersUpvoteValue];
}

-(void)makeDownvoteRequest {
    NSLog(@"[VotingCommand] UPVOTE UN CLICK!....");
    [self makeVotingRequestWithClickType:kParametersTypeClick
                          andVotingValue:kParametersDownvoteValue];
}

-(void)makeUpvoteUnclickRequest {
    NSLog(@"[VotingCommand] DOWNVOTE CLICK!....");
    [self makeVotingRequestWithClickType:kParametersTypeUnClick
                          andVotingValue:kParametersUpvoteValue];

}

-(void)makeDownvoteUnclickRequest {
    NSLog(@"[VotingCommand] DOWNVOTE UN CLICK!....");
    [self makeVotingRequestWithClickType:kParametersTypeUnClick
                          andVotingValue:kParametersDownvoteValue];
}

-(void)makeVotingRequestWithClickType:(NSString*)t andVotingValue:(NSString*)v {
    NSLog(@"[VotingCommand] voting!....");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSLog(@"[VotingCommand] AUTHHHHHHHHH: %@", self.tokenOfAuth);
    
    NSString *url = [NSString stringWithFormat:@"%@/stories/recloud", SERVER_MAIN_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    self.type = t;
    self.value = v;
    NSString *params = [NSString stringWithFormat:@"type=%@&story_id=%d&value=%@&auth_token=%@", t, self.story.idNumber, v, self.tokenOfAuth];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [connection start];
}

#pragma mark connection protocol functions
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"[VotingCommand] conection did receive response!");
    _data = [[NSMutableData alloc] init];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"[VotingCommand] conection did receive data!");
    [_data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // Please do something sensible here, like log the error.
    NSLog(@"[VotingCommand] connection failed with error: %@", error.description);
    
    // stop spinners
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [self.delegate errorOccuredDuringVote:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"[VotingCommand] connectiondidfinishloading!");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
    
    NSLog(@"[VotingCommand] dict response: %@", dictResponse);
    
    BOOL upvoted = [self.type isEqualToString:kParametersTypeClick] && [self.value isEqualToString:kParametersUpvoteValue];
    BOOL undidUpvote = [self.type isEqualToString:kParametersTypeUnClick] && [self.value isEqualToString:kParametersUpvoteValue];
    BOOL downvoted = [self.type isEqualToString:kParametersTypeClick] && [self.value isEqualToString:kParametersDownvoteValue];
    BOOL undidDownvote = [self.type isEqualToString:kParametersTypeUnClick] && [self.value isEqualToString:kParametersDownvoteValue];
    
    if(upvoted) {
        [self.delegate successfulUpvote];
    }
    else if (undidUpvote) {
        [self.delegate successfulUpvoteUnclick];
    }
    else if (downvoted) {
        [self.delegate successfulDownvote];
    }
    else if (undidDownvote) {
        [self.delegate successfulDownvoteUnclick];
    }
    
    
}

@end
