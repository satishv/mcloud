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
#import "collectivlySidebarViewController.h"
#import "collectivlyWebViewController.h"
#import "AsyncImageView.h"
#import "collectivlyUtilities.h"

#import "VotingCommand.h"
#import "RecollectCommand.h"
#import "GetStoryInfoCommand.h"

@interface collectivlyExpandedContentViewController : UIViewController <JTRevealSidebarV2Delegate, collectivlySidebarViewControllerDelegate, NSURLConnectionDataDelegate, VotingRequestDelegate, RecollectCommandDelegate, GetStoryDelegate, UITableViewDataSource, UITableViewDelegate> {
    NSMutableData *_data;
    
    BOOL needToUpvoteAfterDownvoteUnclick, needToDownvoteAfterUpvoteUnclick;
    
    NSArray *comments;
    
    UIColor *lightBlueBGColor, *lightGrayBGColor;
}

@property (retain) collectivlySingleton *currentUser;

@property (nonatomic, retain) collectivlyStory *story;
@property (weak, nonatomic) IBOutlet AsyncImageView *expandedImageView;

@property (retain, nonatomic) IBOutlet collectivlySidebarViewController *rightSideBarViewController;

@property (weak, nonatomic) IBOutlet UIButton *recollectButton;
@property (weak, nonatomic) IBOutlet UIButton *upVoteButton;
@property (weak, nonatomic) IBOutlet UIButton *downVoteButton;

@property (nonatomic, readwrite) BOOL recollected;

@property (weak, nonatomic) IBOutlet UIButton *articleTitleButton;
@property (weak, nonatomic) IBOutlet UILabel *timeAgoLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalCountLabel;
@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;

- (IBAction)centerRecollectButtonTouched:(id)sender;
- (IBAction)downVoteButtonTouched:(id)sender;
- (IBAction)upVoteButtonTouched:(id)sender;
- (IBAction)articleTitleTouched:(id)sender;

@end
