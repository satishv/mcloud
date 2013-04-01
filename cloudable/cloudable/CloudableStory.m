//
//  CloudableStory.m
//  cloudable
//
//  Created by Nathan Fraenkel on 3/28/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import "CloudableStory.h"

@implementation CloudableStory

@synthesize articleImage, expandedImage, image, linkID, ogType, title, summary;
@synthesize categoryID, commentsCount, facebookLikes, idNumber, status, retweets, provider;
@synthesize commentedAt, createdAt, createdTime, updatedAt;
@synthesize commentCategories, computedTags, imageURLs, keywords;
@synthesize computedCategories;
@synthesize url, site, origURL;

- (id)initWithDictionary:(NSDictionary *)story {
    self = [super init];
    if (self) {
//        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//        [dateFormat setDateFormat:@"yyyy-MM-ddTHH:mm:ssZ"];
//        [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        self.articleImage = [NSString stringWithFormat:@"%@", [story objectForKey:@"article_image"]];
        NSLog(@"article image: %@", self.articleImage);
        self.categoryID = (NSInteger)[story objectForKey:@"category_id"];
        NSLog(@"category id: %d", self.categoryID);
        self.commentedAt = [NSString stringWithFormat:@"%@", [story objectForKey:@"commented_at"]];
        NSLog(@"commented at: \"%@\"", self.commentedAt);
        self.commentsCount = (NSInteger)[story objectForKey:@"comments_count"];
        NSLog(@"comments count: %d", self.commentsCount);
        self.computedCategories = [story objectForKey:@"computed_categories"];
        self.computedTags = [story objectForKey:@"computed_tags"];
        self.createdAt = [NSString stringWithFormat:@"%@", [story objectForKey:@"created_at"]];
        self.createdTime = [NSString stringWithFormat:@"%@", [story objectForKey:@"created_time"]];
        //USD?
        self.expandedImage = [NSString stringWithFormat:@"%@", [story objectForKey:@"expanded_image"]];
        self.facebookLikes = (NSInteger)[story objectForKey:@"facebook_likes"];
        self.idNumber = (NSInteger)[story objectForKey:@"id"];
        NSLog(@"identity: %d", self.idNumber);
        self.image = [NSString stringWithFormat:@"%@", [story objectForKey:@"image"]];
        self.imageURLs = [story objectForKey:@"image_urls"];
        if ([imageURLs isKindOfClass:[NSArray class]]){
            for (NSString *imageURL in imageURLs){
                NSLog(@"image url: %@", imageURL);
            }
        }
        self.keywords = [story objectForKey:@"keywords"];
        self.linkID = [NSString stringWithFormat:@"%@", [story objectForKey:@"link_id"]];
        self.ogType = [NSString stringWithFormat:@"%@", [story objectForKey:@"og_type"]];
        self.origURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [story objectForKey:@"orig_url"]]];
        self.provider = (NSInteger)[story objectForKey:@"provider"];
        self.retweets = (NSInteger)[story objectForKey:@"retweets"];
        self.site = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [story objectForKey:@"site"]]];
        self.status = (NSInteger)[story objectForKey:@"status"];
        self.summary = [NSString stringWithFormat:@"summary"];
        self.title = [NSString stringWithFormat:@"title"];
        
        self.updatedAt = [NSString stringWithFormat:@"%@", [story objectForKey:@"updated_at"]];
        self.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [story objectForKey:@"url"]]];
    
    
    }
    return self;
}

@end
