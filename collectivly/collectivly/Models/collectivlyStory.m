//
//  collectivlyStory.m
//  collectivly
//
//  Created by Nathan Fraenkel on 5/16/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import "collectivlyStory.h"

@implementation collectivlyStory

@synthesize articleImage, title, summary, profileImage, friendsCount, totalCount, site, url, idNumber, createdAt, keywords, origURL, articleImageString, imageString, expandedImageString, profileImageString, expandedImage, image, timeAgo;

- (id)initWithDictionaryWithoutFetchingImages:(NSDictionary *)story {
    self = [super init];
    if (self) {
        
        self.articleImageString = [NSString stringWithFormat:@"%@", [story objectForKey:@"article_image"]];
        self.articleImage = nil;
        self.createdAt = [NSString stringWithFormat:@"%@", [story objectForKey:@"created_at"]];
        self.expandedImageString =  [NSString stringWithFormat:@"%@", [story objectForKey:@"expanded_image"]];
        self.expandedImage = nil;
        self.friendsCount = atoi([[NSString stringWithFormat:@"%@", [story objectForKey:@"friends_count"]] UTF8String]);
        self.idNumber = atoi([[NSString stringWithFormat:@"%@", [story objectForKey:@"id"]] UTF8String]);
        self.imageString = [NSString stringWithFormat:@"%@", [story objectForKey:@"image"]];
        self.image = nil;
        self.keywords = [story objectForKey:@"keywords"];
        self.origURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [story objectForKey:@"orig_url"]]];
        NSDictionary *owner = [story objectForKey:@"owner"];
        self.profileImageString = [NSString stringWithFormat:@"%@", [owner objectForKey:@"profile_image"]];
        self.profileImage = nil;
        self.site = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [story objectForKey:@"site"]]];
        self.summary = [NSString stringWithFormat:@"%@", [story objectForKey:@"summary"]];
        self.title = [NSString stringWithFormat:@"%@", [story objectForKey:@"title"]];
        self.totalCount = atoi([[NSString stringWithFormat:@"%@", [story objectForKey:@"total_count"]] UTF8String]);
        self.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [story objectForKey:@"url"]]];
        
        self.timeAgo = nil;
    }
    return self;
}


@end
