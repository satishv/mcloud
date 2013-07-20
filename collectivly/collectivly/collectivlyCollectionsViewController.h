//
//  collectivlyCollectionsViewController.h
//  collectivly
//
//  Created by Nathan Fraenkel on 4/6/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "collectivlySingleton.h"
#import "collectivlyCollection.h"
#import "collectivlyStory.h"
#import "collectivlyStory.h"
#import "JTRevealSidebarV2Delegate.h"
#import "UINavigationItem+JTRevealSidebarV2.h"
#import "UIViewController+JTRevealSidebarV2.h"
#import "collectivlySidebarViewController.h"
#import "MBProgressHUD.h"

#import "GetCollectionsCommand.h"
#import "GetStoriesForCollectionCommand.h"

@interface collectivlyCollectionsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, JTRevealSidebarV2Delegate, collectivlySidebarViewControllerDelegate, MBProgressHUDDelegate, GetCollectionsDelegate, GetStoriesDelegate> {

    NSMutableData *_data;
    
    NSInteger selectedCollection;
    
}

@property (retain) collectivlySingleton *currentUser;

@property (weak, nonatomic) IBOutlet UITableView *collectionsTableView;

@property (retain, nonatomic) collectivlySidebarViewController *rightSideBarViewController;

@property (retain, nonatomic) MBProgressHUD *HUD;

@property (retain, nonatomic) UIRefreshControl *refresherController;

-(IBAction)rightSideBarButtonTouched:(id)sender;

-(void)refreshView;


@end
