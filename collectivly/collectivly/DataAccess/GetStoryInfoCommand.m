//
//  GetStoryInfoCommand.m
//  collectivly
//
//  Created by Nathan Fraenkel on 8/3/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import "GetStoryInfoCommand.h"

@implementation GetStoryInfoCommand

@synthesize story, delegate;

-(id)initWithStory:(collectivlyStory *)st {
    self = [super init];
    if (self) {
        self.story = st;
    }
    return self;
}

-(void)fetchStory {
    NSLog(@"[GetStoryInfoCommand] getting story with id %d and title %@", story.idNumber, story.title);
    
    // spinnaz
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // set URL
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://collectivly.com/stories/%d", story.idNumber]];
    
    // HTTP request, setting stuff
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:10] ;
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

#pragma mark connection protocol functions
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"[GetStoryInfoCommand] conection did receive response!");
    _data = [[NSMutableData alloc] init];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"[GetStoryInfoCommand] conection did receive data!");
    [_data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // Please do something sensible here, like log the error.
    NSLog(@"[GetStoryInfoCommand] connection failed with error: %@", error.description);
    
    // stop spinners
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [self.delegate reactToStoryError:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"[GetStoryInfoCommand] connectiondidfinishloading!");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    
//    NSString *responza = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
    
    NSDictionary *dictResponza = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];

    NSLog(@"STORYresponza: %@", dictResponza);
    
    [self.delegate reactToStoryResponse];
    
}

@end
