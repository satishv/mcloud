//
//  collectivlyStory.m
//  collectivly
//
//  Created by Nathan Fraenkel on 4/6/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import "collectivlyStory.h"

@implementation collectivlyStory

@synthesize articleImage, expandedImage, image, linkID, ogType, title, summary;
@synthesize categoryID, commentsCount, facebookLikes, idNumber, status, retweets, provider;
@synthesize commentedAt, createdAt, createdTime, updatedAt;
@synthesize commentCategories, computedTags, imageURLs, keywords;
@synthesize computedCategories;
@synthesize url, site, origURL;
@synthesize profileImage, friendsCount, totalCount;

- (id)initWithDictionary:(NSDictionary *)story {
    self = [super init];
    if (self) {

        self.articleImage = [self imageFromURLString:[NSString stringWithFormat:@"%@", [story objectForKey:@"article_image"]]];
        NSLog(@"article image: %@", self.articleImage);
        self.categoryID = atoi([[NSString stringWithFormat:@"%@", [story objectForKey:@"category_id"]] UTF8String]);
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
        self.facebookLikes = atoi([[NSString stringWithFormat:@"%@", [story objectForKey:@"facebook_likes"]] UTF8String]);
        self.friendsCount = atoi([[NSString stringWithFormat:@"%@", [story objectForKey:@"friends_count"]] UTF8String]);
        self.idNumber = atoi([[NSString stringWithFormat:@"%@", [story objectForKey:@"id"]] UTF8String]);
        NSLog(@"identity: %d", self.idNumber);
        self.image = [self imageFromURLString:[NSString stringWithFormat:@"%@", [story objectForKey:@"image"]]];
        self.imageURLs = [story objectForKey:@"image_urls"];
        if ([imageURLs isKindOfClass:[NSArray class]]){
            NSLog(@"image urls are not null, and there are more than one!!!");
//            for (NSString *imageURL in imageURLs){
//                NSLog(@"image url: %@", imageURL);
//            }
        }
        self.keywords = [story objectForKey:@"keywords"];
        self.linkID = [NSString stringWithFormat:@"%@", [story objectForKey:@"link_id"]];
        self.ogType = [NSString stringWithFormat:@"%@", [story objectForKey:@"og_type"]];
        self.origURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [story objectForKey:@"orig_url"]]];
        NSDictionary *owner = [story objectForKey:@"owner"];
        self.profileImage = [self imageFromURLString:[NSString stringWithFormat:@"%@", [owner objectForKey:@"profile_image"]]];
        self.provider = (NSInteger)[story objectForKey:@"provider"];
        self.retweets = (NSInteger)[story objectForKey:@"retweets"];
        self.site = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [story objectForKey:@"site"]]];
        self.status = (NSInteger)[story objectForKey:@"status"];
        self.summary = [NSString stringWithFormat:@"%@", [story objectForKey:@"summary"]];
        self.title = [NSString stringWithFormat:@"%@", [story objectForKey:@"title"]];
        self.totalCount = atoi([[NSString stringWithFormat:@"%@", [story objectForKey:@"total_count"]] UTF8String]);
        self.updatedAt = [NSString stringWithFormat:@"%@", [story objectForKey:@"updated_at"]];
        self.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [story objectForKey:@"url"]]];
        
        
    }
    return self;
}

// HELPER - returns image from url. so sexy
- (UIImage *)imageFromURLString:(NSString *)urlString
{
    NSURL *imageURL = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:imageURL];
    [request setHTTPMethod:@"GET"];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //    [request release];
    //    [self handleError:error];
    UIImage *resultImage = [UIImage imageWithData:(NSData *)result];
    
    //    NSLog(@"urlString: %@",urlString);
    return resultImage;
}

@end
