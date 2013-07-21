//
//  RecollectCommand.h
//  collectivly
//
//  Created by Nathan Fraenkel on 7/21/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class collectivlyStory, collectivlyCollection;

@protocol RecollectCommandDelegate <NSObject>
-(void)successfulRecollect;
-(void)errorOccuredDuringRecollect:(NSError*)error;
@end

@interface RecollectCommand : NSObject <NSURLConnectionDataDelegate> {
    NSMutableData *_data;
}

@property (nonatomic, strong) collectivlyStory *story;
@property (nonatomic, strong) collectivlyCollection *coll;
@property (nonatomic, strong) NSString *auth;
@property (nonatomic, strong) id<RecollectCommandDelegate> delegate;

-(id)initWithStory:(collectivlyStory *)st andAuth:(NSString *)token andCollection:(collectivlyCollection *)c;
-(void)makeRecollectRequest;

@end
