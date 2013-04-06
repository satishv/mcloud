//
//  collectivlySingleton.h
//  collectivly
//
//  Created by Nathan Fraenkel on 4/6/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface collectivlySingleton : NSObject {
    NSMutableArray *stories;
    
    BOOL isLoggedIn;
}

@property (nonatomic, readwrite) BOOL isLoggedIn;
@property (nonatomic, retain) NSMutableArray *stories;
@property (nonatomic, retain) NSString *authToken;

+ (collectivlySingleton *) sharedDataModel;


@end
