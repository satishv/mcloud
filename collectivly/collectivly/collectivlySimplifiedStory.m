//
//  collectivlySimplifiedStory.m
//  collectivly
//
//  Created by Nathan Fraenkel on 5/16/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import "collectivlySimplifiedStory.h"

@implementation collectivlySimplifiedStory

@synthesize articleImage, title, summary, profileImage, friendsCount, totalCount, site, url, idNumber, createdAt, keywords, origURL;

- (id)initWithDictionary:(NSDictionary *)story {
    self = [super init];
    if (self) {
        
        self.articleImage = [self imageFromURLString:[NSString stringWithFormat:@"%@", [story objectForKey:@"article_image"]]];
        self.createdAt = [NSString stringWithFormat:@"%@", [story objectForKey:@"created_at"]];
        self.friendsCount = atoi([[NSString stringWithFormat:@"%@", [story objectForKey:@"friends_count"]] UTF8String]);
        self.idNumber = atoi([[NSString stringWithFormat:@"%@", [story objectForKey:@"id"]] UTF8String]);
        self.keywords = [story objectForKey:@"keywords"];
        self.origURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [story objectForKey:@"orig_url"]]];
        NSDictionary *owner = [story objectForKey:@"owner"];
        self.profileImage = [self imageFromURLString:[NSString stringWithFormat:@"%@", [owner objectForKey:@"profile_image"]]];
        self.site = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [story objectForKey:@"site"]]];
        self.summary = [NSString stringWithFormat:@"%@", [story objectForKey:@"summary"]];
        self.title = [NSString stringWithFormat:@"%@", [story objectForKey:@"title"]];
        self.totalCount = atoi([[NSString stringWithFormat:@"%@", [story objectForKey:@"total_count"]] UTF8String]);
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