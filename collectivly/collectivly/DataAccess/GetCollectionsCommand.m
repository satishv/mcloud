//
//  GetCollectionsCommand.m
//  collectivly
//
//  Created by Nathan Fraenkel on 7/14/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import "GetCollectionsCommand.h"

@implementation GetCollectionsCommand

@synthesize userIsLoggedIn, delegate;

-(id)initWithUserAlreadyLoggedInBool:(BOOL)booleano {
    self = [super init];
    if (self) {
        // custom initialization
        self.userIsLoggedIn = booleano;
    }
    return self;
}

-(void)fetchCollections {
    NSLog(@"[GetColletionsCommand] fetching relevant collections.....");
    
    // spinnaz
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // set URL
    NSString *url = @"";
    if ([self userIsLoggedIn]){
        NSLog(@"[GetColletionsCommand] SOMEONE LOGGED IN --> personalized collections!");
        url = @"https://www.collectivly.com/clubb.json";
    }
    else {
        NSLog(@"[GetColletionsCommand] NO ONE LOGGED IN --> popular collections!");
        url = @"https://www.collectivly.com/clubb.json";
    }
    
    // HTTP request, setting stuff
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // start connection
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

#pragma mark connection protocol functions
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"[GetColletionsCommand] conection did receive response!");
    _data = [[NSMutableData alloc] init];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"[GetColletionsCommand] conection did receive data!");
    [_data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // Please do something sensible here, like log the error.
    NSLog(@"[GetColletionsCommand] connection failed with error: %@", error.description);
    
    // stop spinners
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [self.delegate reactToGetCollectionsError:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"[GetColletionsCommand] connectiondidfinishloading!");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
//    NSString *responseString = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
//    NSLog(@"response data: %@", responseString);
    
    NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
                
    NSMutableArray *colls = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in dictResponse){
        collectivlyCollection *cc = [[collectivlyCollection alloc] initWithDictionary:dict];
        
        // add collection to list of collections
        [colls addObject:cc];
    }
    
    [self.delegate reactToGetCollectionsResponse:[NSArray arrayWithArray:colls]];
           
}

@end
