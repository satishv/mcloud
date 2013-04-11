//
//  collectivlyCollection.m
//  collectivly
//
//  Created by Nathan Fraenkel on 4/11/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import "collectivlyCollection.h"

@implementation collectivlyCollection

@synthesize name, tagLine, parentID, rank;
@synthesize createdAt, domain, updatedAt;
@synthesize idNumber, postCount, userID;
@synthesize keywords, websites, image;


- (id)initWithDictionary:(NSDictionary *)collection {
    self = [super init];
    if (self) {
        
        self.createdAt = [NSString stringWithFormat:@"%@", [collection objectForKey:@"created_at"]];
        self.domain = [NSString stringWithFormat:@"%@", [collection objectForKey:@"domain"]];
        self.idNumber = (NSInteger)[collection objectForKey:@"id"];
        self.image = [self imageFromURLString:[NSString stringWithFormat:@"%@", [collection objectForKey:@"image"]]];
        self.keywords = [collection objectForKey:@"keywords"];
        if ([keywords isKindOfClass:[NSArray class]]){
            for (NSString *word in keywords){
                NSLog(@"word: %@", word);
            }
        }
        self.name = [NSString stringWithFormat:@"%@", [collection objectForKey:@"name"]];
        self.parentID= (NSInteger)[collection objectForKey:@"parent_id"];
        NSLog(@"parent id: %d", parentID);
        self.postCount = (NSInteger)[collection objectForKey:@"post_count"];
        self.rank = (NSInteger)[collection objectForKey:@"rank"];
        self.tagLine = [collection objectForKey:@"tag_line"];
        self.updatedAt = [collection objectForKey:@"updated_at"];
        self.userID = (NSInteger)[collection objectForKey:@"user_id"];
        self.websites = [collection objectForKey:@"websites"];
        if ([websites isKindOfClass:[NSArray class]]){
            for (NSString *site in websites){
                NSLog(@"website: %@", site);
            }
        }
        // done!
    }
    return self;
}

// HELPER - returns image from url. so sexy
- (UIImage *)imageFromURLString:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
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
