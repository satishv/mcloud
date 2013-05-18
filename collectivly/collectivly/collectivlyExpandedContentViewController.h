//
//  collectivlyExpandedContentViewController.h
//  collectivly
//
//  Created by Nathan Fraenkel on 5/17/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "collectivlySingleton.h"
#import "collectivlyStory.h"
#import "JTRevealSidebarV2Delegate.h"
#import "UINavigationItem+JTRevealSidebarV2.h"
#import "UIViewController+JTRevealSidebarV2.h"
#import "SidebarViewController.h"

@interface collectivlyExpandedContentViewController : UIViewController <JTRevealSidebarV2Delegate, SidebarViewControllerDelegate>

@property (retain) collectivlySingleton *currentUser;

@property (nonatomic, retain) collectivlyStory *story;
@property (retain, nonatomic) IBOutlet UIImageView *expandedImageView;

@property (retain, nonatomic) IBOutlet SidebarViewController *rightSideBarViewController;


@end
