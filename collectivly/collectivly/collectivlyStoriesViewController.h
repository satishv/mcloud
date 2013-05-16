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
#import "collectivlySimplifiedStory.h"
#import "JTRevealSidebarV2Delegate.h"
#import "UINavigationItem+JTRevealSidebarV2.h"
#import "UIViewController+JTRevealSidebarV2.h"
#import "SidebarViewController.h"


@interface collectivlyStoriesViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, NSURLConnectionDataDelegate, JTRevealSidebarV2Delegate, SidebarViewControllerDelegate> {

    NSMutableData *_data;
}

@property (retain) collectivlySingleton *currentUser;

@property (nonatomic, retain) NSArray *stories;

@property (retain, nonatomic) IBOutlet SidebarViewController *rightSideBarViewController;


@end
