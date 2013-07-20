//
//  RequestInviteCommand.m
//  collectivly
//
//  Created by Nathan Fraenkel on 7/20/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import "RequestInviteCommand.h"

@implementation RequestInviteCommand

@synthesize first, last, email, password, delegate;

-(id)initWithFirst:(NSString *)f andLast:(NSString *)l andEmail:(NSString *)e andPass:(NSString *)p {
    self = [super init];
    if (self) {
        // custom init
        self.first = f;
        self.last = l;
        self.email = e;
        self.password = p;
    }
    return self;
}

-(void)requestInvite {
    
    NSLog(@"[RequestInviteCommand] requesting invite....");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSMutableDictionary *user = [[NSMutableDictionary alloc] init];
    [user setValue:first forKey:@"first_name"];
    [user setValue:last forKey:@"last_name"];
    [user setValue:email forKey:@"email"];
    [user setValue:password forKey:@"password"];
    [user setValue:password forKey:@"password_confirmation"];
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    [dataDict setValue:@"" forKey:@"authenticity_token"];
    [dataDict setValue:user forKey:@"user"];

    NSString *url = @"https://collectivly.com/users/invitation";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];

    NSString *data = [NSString stringWithFormat:@""];
    NSData *postData = ([NSJSONSerialization isValidJSONObject:dataDict]) ? [NSJSONSerialization dataWithJSONObject:dataDict options:NSJSONWritingPrettyPrinted error:nil] : [data dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@", postData);

    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];

    // HTTP request, setting stuff
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];

    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];

}

#pragma mark connection protocol functions
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"[RequestInviteCommand] conection did receive response!");
    _data = [[NSMutableData alloc] init];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"[RequestInviteCommand] conection did receive data!");
    [_data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // Please do something sensible here, like log the error.
    NSLog(@"[RequestInviteCommand] connection failed with error: %@", error.description);
    
    // stop spinners
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [self.delegate errorOccuredDuringInvite:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"[RequestInviteCommand] connectiondidfinishloading!");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSString *responseString = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
    NSLog(@"response data: %@", responseString);
    
    NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
    
    BOOL inviteWasASuccess = [[dictResponse objectForKey:kJsonResponseKeyRequestInviteStatus] isEqualToString:kJsonResponseValueRequestInviteSuccess];
    
    if (inviteWasASuccess){
        [self.delegate successfulInviteWithMessage:[dictResponse objectForKey:kJsonResponseKeyRequestInviteMessage]];
    }
    else {
        [self.delegate unsuccessfulInvite];
    }
    
}

@end
