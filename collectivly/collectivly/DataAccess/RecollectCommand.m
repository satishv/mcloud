//
//  RecollectCommand.m
//  collectivly
//
//  Created by Nathan Fraenkel on 7/21/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import "RecollectCommand.h"
#import "collectivlyStory.h"
#import "collectivlyCollection.h"

@implementation RecollectCommand

@synthesize story, delegate, coll, auth;

-(id)initWithStory:(collectivlyStory *)st andAuth:(NSString *)token andCollection:(collectivlyCollection *)c {
    self = [super init];
    if (self) {
        self.story = st;
        self.auth = token;
        self.coll = c;
    }
    return self;
}

-(void)makeRecollectRequest {
    NSLog(@"[RecollectCommand] recollecting story.....");
    
    // spinnaz
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // set up parameters
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    [dataDict setValue:self.auth forKey:@"authenticity_token"];
    [dataDict setValue:[NSString stringWithFormat:@"%d", self.coll.idNumber] forKey:@"cl_category"];
    [dataDict setValue:@"" forKey:@"cl_comment"];
    [dataDict setValue:[NSString stringWithFormat:@"%d", self.story.idNumber] forKey:@"story_id"];
    [dataDict setValue:@"1" forKey:@"scope"]; // DEFAULT: 1 = public
    
    NSString *url = @"https://collectivly.com/stories/recloud";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSString *data = [NSString stringWithFormat:@""];
    NSData *postData = ([NSJSONSerialization isValidJSONObject:dataDict]) ? [NSJSONSerialization dataWithJSONObject:dataDict options:NSJSONWritingPrettyPrinted error:nil] : [data dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    // HTTP request, setting stuff
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody:postData];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

#pragma mark connection protocol functions
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"[RecollectCommand] conection did receive response!");
    _data = [[NSMutableData alloc] init];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"[RecollectCommand] conection did receive data!");
    [_data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // Please do something sensible here, like log the error.
    NSLog(@"[RecollectCommand] connection failed with error: %@", error.description);
    
    // stop spinners
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [self.delegate errorOccuredDuringRecollect:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"[RecollectCommand] connectiondidfinishloading!");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
    
    
    [self.delegate successfulRecollect];
    
}




@end
