//
//  CloudableStory.h
//  cloudable
//
//  Created by Nathan Fraenkel on 3/28/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CloudableStory : NSObject {
    NSString *articleImage, *expandedImage, *image, *linkID, *ogType, *title, *summary;
    NSString *commentedAt, *createdAt, *createdTime, *updatedAt;
    NSInteger categoryID, commentsCount, facebookLikes, idNumber, status, retweets, provider;
    NSArray *commentCategories, *computedTags, *imageURLs, *keywords;
    NSDictionary *computedCategories;
    // expires_at??
    // lat??
    // upc??
    // unclouds??
    // twitter creator??
    // tw_type??
    // rank??
            // article, etc.
    // owner_comment??
    // price??
    // rank??
    // lng??
    // nil_fileds_filled_at??
    // currency??
            // USD, etc.
    NSURL *url, *site, *origURL;
    
}

@property (retain, nonatomic) NSString *articleImage, *expandedImage, *image, *linkID, *ogType, *title, *summary;
@property (assign, nonatomic) NSInteger categoryID, commentsCount, facebookLikes, idNumber, status, retweets, provider;
@property (retain, nonatomic) NSString *commentedAt, *createdAt, *createdTime, *updatedAt;
@property (retain, nonatomic) NSArray *commentCategories, *computedTags, *imageURLs, *keywords;
@property (retain, nonatomic) NSDictionary *computedCategories;
@property (retain, nonatomic) NSURL *url, *site, *origURL;

-(id)initWithDictionary:(NSDictionary *)story;

@end
