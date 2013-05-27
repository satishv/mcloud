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
#import "collectivlySimplifiedStory.h"
#import "JTRevealSidebarV2Delegate.h"
#import "UINavigationItem+JTRevealSidebarV2.h"
#import "UIViewController+JTRevealSidebarV2.h"
#import "collectivlySidebarViewController.h"
#import "MBProgressHUD.h"

@interface collectivlyCollectionsViewController : UIViewController <NSURLConnectionDataDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate, JTRevealSidebarV2Delegate, collectivlySidebarViewControllerDelegate, MBProgressHUDDelegate> {
    int requestNumber;
    NSMutableData *_data;
    
    UIImageView *ithCollectionBG;
    
}

@property (retain) collectivlySingleton *currentUser;

@property (retain, nonatomic) IBOutlet UIImageView *firstCollectionImage;
@property (retain, nonatomic) IBOutlet UILabel *firstTitle;

@property (retain, nonatomic) IBOutlet UIScrollView *scrolley;

@property (retain, nonatomic) collectivlySidebarViewController *rightSideBarViewController;

@property (retain, nonatomic) MBProgressHUD *HUD;

-(IBAction)rightSideBarButtonTouched:(id)sender;

-(void)refreshView;


@end
