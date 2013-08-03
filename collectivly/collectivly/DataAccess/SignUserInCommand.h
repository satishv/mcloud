//
//  SignUserInCommand.h
//  collectivly
//
//  Created by Nathan Fraenkel on 7/20/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SignUserInDelegate <NSObject>
-(void)successfulSignInWithSuccessDict:(NSDictionary*)dict;
-(void)errorOccuredDuringSignIn:(NSError*)error;
-(void)unsuccessfulSignInWithMessage:(NSString*)msg;
@end

@interface SignUserInCommand : NSObject <NSURLConnectionDataDelegate> {
    NSMutableData *_data;
}

@property (nonatomic, strong) NSString *email, *password;
@property (nonatomic, strong) id<SignUserInDelegate> delegate;

-(id)initWithEmail:(NSString*)e andPass:(NSString*)p;
-(void)signUserIn;

@end
