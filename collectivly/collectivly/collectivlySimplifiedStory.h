//
//  collectivlySimplifiedStory.h
//  collectivly
//
//  Created by Nathan Fraenkel on 5/16/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface collectivlySimplifiedStory : NSObject {
    
    NSString *articleImageString, *profileImageString, *imageString, *expandedImageString;
    UIImage *articleImage, *profileImage, *image, *expandedImage;
    NSString *title, *summary;
    NSString *createdAt;
    NSInteger idNumber, friendsCount, totalCount;
    NSArray *keywords;
    NSURL *url, *site, *origURL;
    
}

@property (retain, nonatomic) UIImage *articleImage, *profileImage, *image, *expandedImage;
@property (retain, nonatomic) NSString *title, *summary, *articleImageString, *profileImageString, *imageString, *expandedImageString, *timeAgo;
@property (assign, nonatomic) NSInteger idNumber, friendsCount, totalCount;
@property (retain, nonatomic) NSString *createdAt;
@property (retain, nonatomic) NSArray *keywords;
@property (retain, nonatomic) NSURL *url, *site, *origURL;

-(id)initWithDictionary:(NSDictionary *)story;
- (UIImage *)imageFromURLString:(NSString *)urlString;

@end
