//
//  RequestInviteCommand.h
//  collectivly
//
//  Created by Nathan Fraenkel on 7/20/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RequestInviteDelegate <NSObject>
-(void)successfulInviteWithMessage:(NSString*)message;
-(void)errorOccuredDuringInvite:(NSError*)error;
-(void)unsuccessfulInvite;
@end

@interface RequestInviteCommand : NSObject <NSURLConnectionDataDelegate> {
    NSMutableData *_data;
}

@property (nonatomic, strong) NSString *first, *last, *email, *password;
@property (nonatomic, strong) id<RequestInviteDelegate> delegate;

-(id)initWithFirst:(NSString*)f andLast:(NSString*)l andEmail:(NSString*)e andPass:(NSString*)p;
-(void)requestInvite;


@end
