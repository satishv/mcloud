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
#import "SidebarViewController.h"

@interface collectivlyCollectionsViewController : UIViewController <NSURLConnectionDataDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate, JTRevealSidebarV2Delegate, SidebarViewControllerDelegate> {
    int requestNumber;
    NSMutableData *_data;
    
    UIImageView *ithCollectionBG;
    
}

@property (retain) collectivlySingleton *currentUser;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (retain, nonatomic) IBOutlet UIImageView *firstCollectionBG;
@property (retain, nonatomic) IBOutlet UIImageView *secondCollectionBG;
@property (retain, nonatomic) IBOutlet UIImageView *thirdCollectionBG;
@property (retain, nonatomic) IBOutlet UIImageView *fourthCollectionBG;

@property (retain, nonatomic) IBOutlet UILabel *firstTitle;
@property (retain, nonatomic) IBOutlet UILabel *secondTitle;
@property (retain, nonatomic) IBOutlet UILabel *thirdTitle;
@property (retain, nonatomic) IBOutlet UILabel *fourthTitle;

@property (retain, nonatomic) IBOutlet UIScrollView *scrolley;

@property (retain, nonatomic) IBOutlet SidebarViewController *rightSideBarViewController;

-(IBAction)rightSideBarButtonTouched:(id)sender;

-(void)refreshView;


@end
