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
#import "JTRevealSidebarV2Delegate.h"
#import "UINavigationItem+JTRevealSidebarV2.h"
#import "UIViewController+JTRevealSidebarV2.h"
#import "collectivlySidebarViewController.h"
#import "AsyncImageView.h"

#import "GetStoriesForCollectionCommand.h"


@interface collectivlyStoriesViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, JTRevealSidebarV2Delegate, collectivlySidebarViewControllerDelegate, GetStoriesDelegate> {

    NSInteger pageOfStories; // STARTS AT 1
    NSMutableData *_data;
    
    BOOL hasReachedTheEnd;
}

@property (retain) collectivlySingleton *currentUser;

@property (nonatomic, retain) NSMutableArray *stories;

@property (retain, nonatomic) IBOutlet collectivlySidebarViewController *rightSideBarViewController;

@property (retain, nonatomic) UIActivityIndicatorView *activityIndicatorForLoadingMoreStories;

@end
