//
//  CloudableCurrentLoggedInUser.h
//  cloudable
//
//  Created by Nathan Fraenkel on 3/24/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CloudableCurrentLoggedInUser : NSObject {
    NSMutableArray *stories;
    
    BOOL isLoggedIn;
}

@property (nonatomic, readwrite) BOOL isLoggedIn;
@property (nonatomic, retain) NSMutableArray *stories;

+ (CloudableCurrentLoggedInUser *) sharedDataModel;


@end
