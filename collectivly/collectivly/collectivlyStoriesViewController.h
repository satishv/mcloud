//
//  collectivlyStoriesViewController.h
//  collectivly
//
//  Created by Nathan Fraenkel on 4/19/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "collectivlySingleton.h"
#import "collectivlyStory.h"

@interface collectivlyStoriesViewController : UITableViewController

@property (retain) collectivlySingleton *currentUser;

@property (nonatomic, retain) NSArray *stories;


@end
