//
//  collectivlyExpandedContentViewController.m
//  collectivly
//
//  Created by Nathan Fraenkel on 5/17/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import "collectivlyExpandedContentViewController.h"

#define NAVBARHEIGHT        44
#define STATUSBARHEIGHT     20

@interface collectivlyExpandedContentViewController ()

@end

@implementation collectivlyExpandedContentViewController

@synthesize currentUser, expandedImageView, story, rightSideBarViewController, totalCountLabel, friendsCountLabel, timeAgoLabel, articleTitleButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.currentUser = [collectivlySingleton sharedDataModel];
    
    // SET STORY to current story!
    self.story = self.currentUser.currentStory;
    
    // update UI elements to match story's elements
    self.expandedImageView.image = self.story.expandedImage;
    
    self.timeAgoLabel.text = self.story.timeAgo;
    self.totalCountLabel.text = [NSString stringWithFormat:@"%d", self.story.totalCount];
    self.friendsCountLabel.text = [NSString stringWithFormat:@"%d", self.story.friendsCount];
    
    // TODO: fix: cuts off end of title if takes up more than 4 lines.... ideally, would like ... at the end
    self.articleTitleButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.articleTitleButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.articleTitleButton.titleLabel.numberOfLines = 4;
    UIFont *articleTitleFont = [UIFont fontWithName:@"ProximaNova-Bold" size:26];
    [self.articleTitleButton setTitle:self.story.title forState:UIControlStateNormal];
    self.articleTitleButton.titleLabel.font = articleTitleFont;
    
//    CGRect screenBound = [[UIScreen mainScreen] bounds];
//    NSLog(@"screen height and width: %f and %f", screenBound.size.height, screenBound.size.width);
    
    // set up the nav bar, obvi
    [self setUpNavBar];

}

-(void)setUpNavBar {
    
    // customize LEFT / BACK bar button item
    UIImage* logo = [UIImage imageNamed:@"logo.png"];
    NSInteger logoOffset = 26;
    CGRect logoframe = CGRectMake(logoOffset*2, logoOffset, logo.size.width - logoOffset, logo.size.height - logoOffset);
    UIButton *logoButton = [[UIButton alloc] initWithFrame:logoframe];
    [logoButton setBackgroundImage:logo forState:UIControlStateNormal];
    [logoButton addTarget:self action:@selector(leftBarButtonItemTouched:) forControlEvents:UIControlEventTouchUpInside];
    [logoButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *backToCollections =[[UIBarButtonItem alloc] initWithCustomView:logoButton];
    self.navigationItem.leftBarButtonItem = backToCollections;
    
    // customize nav bar RIGHT bar button item
    UIImage* threeBars = [UIImage imageNamed:@"options menu.png"];
    NSInteger offset = 12;
    CGRect frameimg = CGRectMake(offset, offset, threeBars.size.width - offset, threeBars.size.height - offset);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:threeBars forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(rightSideBarButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *showOptions =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    self.navigationItem.rightBarButtonItem = showOptions;
    
    // customize TITLE LABEL
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"ProximaNova-Bold" size:16];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor =[UIColor whiteColor];
    label.text = [[NSString stringWithFormat:@"%@", self.story.title] uppercaseString];
    self.navigationItem.titleView = label;
    
    // set side bar view delegate
    self.navigationItem.revealSidebarDelegate = self;
    
}

- (IBAction)rightSideBarButtonTouched:(id)sender {
    NSLog(@"[collectivlyStoriesViewController] OPTIONS MENU touched");
    [self.navigationController toggleRevealState:JTRevealedStateRight];
}

- (IBAction)leftBarButtonItemTouched:(id)sender {
    NSLog(@"[collectivlyStoriesViewController] BACK BUTTON / COLLECTIVLY LOGO HIT for collection: %@", self.title);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark SidebarViewControllerDelegate

- (void)sidebarViewController:(SidebarViewController *)sidebarViewController didSelectObject:(NSObject *)object atIndexPath:(NSIndexPath *)indexPath {
    
    [sidebarViewController.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.navigationController setRevealedState:JTRevealedStateNo];
    
    NSLog(@"[collectivlyStoriesViewController] SIDEBARRRRRR DIDSELECTOBJECT: %@", object.description);
    if ([object isKindOfClass:[NSString class]]){
        NSString *string = (NSString *)object;
        if ([string isEqualToString:@"Login"]){
            [self performSegueWithIdentifier:@"loginsignupfromstory" sender:self];
        }
    }
    
}

//- (NSIndexPath *)lastSelectedIndexPathForSidebarViewController:(SidebarViewController *)sidebarViewController {
//    return self.rightSelectedIndexPath;
//}

#pragma mark JTRevealSidebarDelegate

// This is an examle to configure your sidebar view through a custom UIViewController
- (UIView *)viewForRightSidebar {
    // Use applicationViewFrame to get the correctly calculated view's frame
    // for use as a reference to our sidebar's view
    CGRect viewFrame = self.navigationController.applicationViewFrame;
    SidebarViewController *controller = self.rightSideBarViewController;
    if ( ! controller) {
        self.rightSideBarViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RIGHT"];
        self.rightSideBarViewController.sidebarDelegate = self;
        controller = self.rightSideBarViewController;
        controller.navigationItem.title = @"Settings";
        controller.title = @"Settings";
    }
    controller.view.frame = CGRectMake(0, viewFrame.origin.y, 270, viewFrame.size.height);
    controller.view.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    return controller.view;
}

// Optional delegate methods for additional configuration after reveal state changed
- (void)didChangeRevealedStateForViewController:(UIViewController *)viewController {
    // Example to disable userInteraction on content view while sidebar is revealing
    if (viewController.revealedState == JTRevealedStateNo) {
        self.view.userInteractionEnabled = YES;
    } else {
        self.view.userInteractionEnabled = NO;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)centerRecollectButtonTouched:(id)sender {
    // TODO
    NSLog(@"!!!!!!!!!! RECOLLECT !!!!!!!!!!");
}

- (IBAction)downVoteButtonTouched:(id)sender {
    // TODO
    NSLog(@"!!!!!!!!!! DOWNVOTE !!!!!!!!!!");
    
}

- (IBAction)upVoteButtonTouched:(id)sender {
    // TODO
    NSLog(@"!!!!!!!!!! UPVOTE !!!!!!!!!!");

}

- (IBAction)articleTitleTouched:(id)sender {
    NSLog(@"!!!!!!!!!! TOUCHED ARTICLE TITLE !!!!!!!!!!");
    NSLog(@"title: %@", self.articleTitleButton.titleLabel.text);
    
    NSLog(@"url to go to: %@", self.story.origURL);

    [[UIApplication sharedApplication] openURL:self.story.origURL];
}
@end
