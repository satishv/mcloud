//
//  SignUserInCommand.m
//  collectivly
//
//  Created by Nathan Fraenkel on 7/20/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import "SignUserInCommand.h"

@implementation SignUserInCommand

@synthesize email, password, delegate;

-(id)initWithEmail:(NSString *)e andPass:(NSString *)p {
    self = [super init];
    if (self) {
        // custom init
        self.email = e;
        self.password = p;

    }
    return self;
}

-(void)signUserIn {
    
    NSLog(@"[SignUserInCommand] signing in....");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *url = @"https://collectivly.com/users/sign_in";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    NSString *params = [NSString stringWithFormat:@"email=%@&password=%@", self.email, self.password];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

#pragma mark connection protocol functions
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"[SignUserInCommand] conection did receive response!");
    _data = [[NSMutableData alloc] init];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"[SignUserInCommand] conection did receive data!");
    [_data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // Please do something sensible here, like log the error.
    NSLog(@"[SignUserInCommand] connection failed with error: %@", error.description);
    
    // stop spinners
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [self.delegate errorOccuredDuringSignIn:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"[SignUserInCommand] connectiondidfinishloading!");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
    
    NSLog(@"[SignUserInCommand] dictresponse: %@", dictResponse);
    
    NSNumber * isSuccessNumber = (NSNumber *)[dictResponse objectForKey:kJsonResponseKeyLoginSuccess];
    BOOL successful = isSuccessNumber && [isSuccessNumber boolValue] == YES;
    
    if(successful) {
        [self.delegate successfulSignInWithSuccessDict:dictResponse];
    }
    else {
        NSString *msg = [dictResponse objectForKey:kJsonResponseKeyLoginFailMessage];
        [self.delegate unsuccessfulSignInWithMessage:msg];
    }
    
}


@end
