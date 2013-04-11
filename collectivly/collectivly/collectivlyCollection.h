//
//  collectivlyCollection.h
//  collectivly
//
//  Created by Nathan Fraenkel on 4/11/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface collectivlyCollection : NSObject {

NSString *name, *tagLine;
NSString *createdAt, *domain, *updatedAt;
NSInteger idNumber, postCount, parentID, rank, userID;
NSArray *keywords, *websites;
UIImage *image;

}

@property (retain, nonatomic) NSString *name, *tagLine;
@property (retain, nonatomic) NSString *createdAt, *domain, *updatedAt;
@property (assign, nonatomic) NSInteger idNumber, postCount, parentID, rank, userID;
@property (retain, nonatomic) NSArray *keywords, *websites;
@property (retain, nonatomic) UIImage *image;

-(id)initWithDictionary:(NSDictionary *)collection;

@end
