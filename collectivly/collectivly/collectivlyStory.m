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
@synthesize commentedAt, createdAt, createdTime, updatedAt, timeAgo;
@synthesize commentCategories, computedTags, imageURLs, keywords;
@synthesize computedCategories;
@synthesize url, site, origURL;
@synthesize profileImage, friendsCount, totalCount;

- (id)initWithDictionary:(NSDictionary *)story {
    self = [super init];
    if (self) {

        self.articleImage = [self imageFromURLString:[NSString stringWithFormat:@"%@", [story objectForKey:@"article_image"]]];
//        NSLog(@"article image: %@", self.articleImage);
        self.categoryID = [[NSString stringWithFormat:@"%@", [story objectForKey:@"category_id"]] integerValue];
//        NSLog(@"category id: %d", self.categoryID);
        self.commentedAt = [NSString stringWithFormat:@"%@", [story objectForKey:@"commented_at"]];
//        NSLog(@"commented at: \"%@\"", self.commentedAt);
        self.commentsCount = [[story objectForKey:@"comments_count"] integerValue];
//        NSLog(@"comments count: %d", self.commentsCount);
        self.computedCategories = [story objectForKey:@"computed_categories"];
        self.computedTags = [story objectForKey:@"computed_tags"];
        self.createdAt = [NSString stringWithFormat:@"%@", [story objectForKey:@"created_at"]];
        self.createdTime = [NSString stringWithFormat:@"%@", [story objectForKey:@"created_time"]];
        //USD?
        self.expandedImage = [self imageFromURLString:[NSString stringWithFormat:@"%@", [story objectForKey:@"expanded_image"]]];
        self.facebookLikes = [[NSString stringWithFormat:@"%@", [story objectForKey:@"facebook_likes"]] integerValue];
        self.friendsCount = [[NSString stringWithFormat:@"%@", [story objectForKey:@"friends_count"]] integerValue];
        self.idNumber = [[NSString stringWithFormat:@"%@", [story objectForKey:@"id"]] integerValue];
//        NSLog(@"identity: %d", self.idNumber);
        self.image = [self imageFromURLString:[NSString stringWithFormat:@"%@", [story objectForKey:@"image"]]];
//        self.imageURLs = [story objectForKey:@"image_urls"];
//        if ([imageURLs isKindOfClass:[NSArray class]]){
//            NSLog(@"image urls are not null, and there are more than one!!!");
//            for (NSString *imageURL in imageURLs){
//                NSLog(@"image url: %@", imageURL);
//            }
//        }
        self.keywords = [story objectForKey:@"keywords"];
        self.linkID = [NSString stringWithFormat:@"%@", [story objectForKey:@"link_id"]];
        self.ogType = [NSString stringWithFormat:@"%@", [story objectForKey:@"og_type"]];
        self.origURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [story objectForKey:@"orig_url"]]];
        self.profileImage = [self imageFromURLString:[NSString stringWithFormat:@"%@", [[story objectForKey:@"owner"] objectForKey:@"profile_image"]]];
        self.provider = [[story objectForKey:@"provider"] integerValue];
        self.retweets = [[story objectForKey:@"retweets"] integerValue];
        self.site = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [story objectForKey:@"site"]]];
        self.status = [[story objectForKey:@"status"] integerValue];
        self.summary = [NSString stringWithFormat:@"%@", [story objectForKey:@"summary"]];
        self.title = [NSString stringWithFormat:@"%@", [story objectForKey:@"title"]];
        self.totalCount = [[NSString stringWithFormat:@"%@", [story objectForKey:@"total_count"]] integerValue];
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
