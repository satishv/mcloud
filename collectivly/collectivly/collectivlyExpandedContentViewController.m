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

@synthesize currentUser, expandedImageView, story, rightSideBarViewController, totalCountLabel, friendsCountLabel, timeAgoLabel, articleTitleButton, recollectButton, recollected, upVoteButton, downVoteButton;

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

    [self.expandedImageView setImage:self.story.articleImage];
    [self.expandedImageView setImageURL:[NSURL URLWithString:self.story.expandedImageString]];
    
    self.timeAgoLabel.text = self.story.timeAgo;
    self.totalCountLabel.text = [NSString stringWithFormat:@"%d", self.story.totalCount];
    self.friendsCountLabel.text = [NSString stringWithFormat:@"%d", self.story.friendsCount];
    
    self.articleTitleButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.articleTitleButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.articleTitleButton.titleLabel.numberOfLines = 4;
    UIFont *articleTitleFont = [UIFont fontWithName:@"ProximaNova-Bold" size:26];
    [self.articleTitleButton setTitle:self.story.title forState:UIControlStateNormal];
    self.articleTitleButton.titleLabel.font = articleTitleFont;
        
    // set up the nav bar, obvi
    [self setUpNavBar];
    
    NSLog(@"EXPANDEDSTORY: %@", self.story.title);

}

#pragma mark - nav bar and bar button item setup
-(void)setUpNavBar {
    
    // customize LEFT / BACK bar button item
    UIImage* logo = [UIImage imageNamed:@"back_logo.png"];
    NSInteger logoOffset = 32;
    CGRect logoframe = CGRectMake(logoOffset, logoOffset*4, logo.size.width - logoOffset*2, logo.size.height - logoOffset);
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

#pragma mark - SIDEBAR
#pragma mark SidebarViewControllerDelegate

- (void)sidebarViewController:(collectivlySidebarViewController *)sidebarViewController didSelectObject:(NSObject *)object atIndexPath:(NSIndexPath *)indexPath {
    
    [sidebarViewController.table deselectRowAtIndexPath:indexPath animated:YES];
    
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
    collectivlySidebarViewController *controller = self.rightSideBarViewController;
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

#pragma mark - COMMAND execution
-(void)makeRecollectRequest {
    RecollectCommand *cmd = [[RecollectCommand alloc]
                             initWithStory:self.story
                             andAuth:self.currentUser.authToken
                             andCollection:self.currentUser.currentCollection];
    cmd.delegate = self;
    [cmd makeRecollectRequest];
}

-(void)makeUpVoteRequest {

    VotingCommand *cmd = [[VotingCommand alloc]
                                 initWithStory:self.story
                                 andToken:self.currentUser.authToken];
    cmd.delegate = self;
    [cmd makeUpvoteRequest];
}

-(void)makeUpVoteUnclickRequest {
    VotingCommand *cmd = [[VotingCommand alloc]
                          initWithStory:self.story
                          andToken:self.currentUser.authToken];
    cmd.delegate = self;
    [cmd makeUpvoteUnclickRequest];
}

-(void)makeDownVoteUnclickRequest {
    VotingCommand *cmd = [[VotingCommand alloc]
                          initWithStory:self.story
                          andToken:self.currentUser.authToken];
    cmd.delegate = self;
    [cmd makeDownvoteUnclickRequest];
}

-(void)makeDownVoteRequest {

    VotingCommand *cmd = [[VotingCommand alloc]
                          initWithStory:self.story
                          andToken:self.currentUser.authToken];
    cmd.delegate = self;
    [cmd makeDownvoteRequest];
    
}

#pragma mark - IBActions / button touch recognizers

- (IBAction)centerRecollectButtonTouched:(id)sender {
    if (!self.currentUser.isLoggedIn){
        [self popupAlertIfUserNotLoggedIn];
        return;
    }
    
    NSLog(@"!!!!!!!!!! RECOLLECT !!!!!!!!!!");
    if (!recollectButton.isSelected){
        self.recollectButton.userInteractionEnabled = NO;
        
        [self makeRecollectRequest];
        
    }
    
}

- (IBAction)downVoteButtonTouched:(id)sender {
    if (!self.currentUser.isLoggedIn){
        [self popupAlertIfUserNotLoggedIn];
        return;
    }
    
    NSLog(@"!!!!!!!!!! DOWNVOTE !!!!!!!!!!");
    self.downVoteButton.userInteractionEnabled = NO;
    
    if (!downVoteButton.isSelected){
        if (upVoteButton.isSelected){
            needToDownvoteAfterUpvoteUnclick = YES;
            [self makeUpVoteUnclickRequest];
        }
        else
            [self makeDownVoteRequest];
    }
    else {
        [self makeDownVoteUnclickRequest];
    }
    
    
    
}

- (IBAction)upVoteButtonTouched:(id)sender {
    if (!self.currentUser.isLoggedIn){
        [self popupAlertIfUserNotLoggedIn];
        return;
    }
    
    NSLog(@"!!!!!!!!!! UPVOTE !!!!!!!!!!");
    
    self.upVoteButton.userInteractionEnabled = NO;
    
    if (!upVoteButton.isSelected){
        if (downVoteButton.isSelected){
            needToUpvoteAfterDownvoteUnclick = YES;
            [self makeDownVoteUnclickRequest];
        }
        else 
            [self makeUpVoteRequest];
    }
    else {
        [self makeUpVoteUnclickRequest];
    }
    
}

- (IBAction)articleTitleTouched:(id)sender {
    NSLog(@"!!!!!!!!!! TOUCHED ARTICLE TITLE !!!!!!!!!!");
    NSLog(@"title: %@", self.articleTitleButton.titleLabel.text);
    
    NSLog(@"url to go to: %@", self.story.origURL);
    
    [self performSegueWithIdentifier:@"showWebView" sender:self];
    
//    [[UIApplication sharedApplication] openURL:self.story.origURL];
}

#pragma mark - COMMAND DELEGATES
#pragma mark upvoting
-(void)successfulUpvote {
    NSLog(@"upvote successful");
    upVoteButton.userInteractionEnabled = YES;

    [self.upVoteButton setSelected:YES];
}

-(void)successfulUpvoteUnclick {
    NSLog(@"upvote UNDOING successful");
    upVoteButton.userInteractionEnabled = YES;
    
    [upVoteButton setSelected:NO];
    
    if (needToDownvoteAfterUpvoteUnclick) {
        
        [self makeDownVoteRequest];
        
        needToDownvoteAfterUpvoteUnclick = NO;
    }
    
    
}
#pragma mark downvoting
-(void)successfulDownvote {
    NSLog(@"downvote successful");
    downVoteButton.userInteractionEnabled = YES;
    
    [downVoteButton setSelected:YES];
}
-(void)successfulDownvoteUnclick {
    NSLog(@"downvote UNDOING successful");
    downVoteButton.userInteractionEnabled = YES;
    
    [downVoteButton setSelected:NO];
    
    if (needToUpvoteAfterDownvoteUnclick) {
        
        [self makeUpVoteRequest];
        
        needToUpvoteAfterDownvoteUnclick = NO;
    }
}

#pragma mark voting error :(
-(void)errorOccuredDuringVote:(NSError *)error {
    [collectivlyUtilities createAndShowDismissableAlertviewWithTitle:@"Error While Voting"
                                                          andMessage:error.localizedDescription];
}

#pragma mark recollecting
-(void)successfulRecollect {
    NSLog(@"successful recollect");
    recollectButton.userInteractionEnabled = YES;
    
    [recollectButton setSelected:YES];
}

-(void)errorOccuredDuringRecollect:(NSError *)error {
    [collectivlyUtilities createAndShowDismissableAlertviewWithTitle:@"Error While Recollecting"
                                                          andMessage:error.localizedDescription];

}

#pragma mark - helpers
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showWebView"]) {
        collectivlyWebViewController *w = (collectivlyWebViewController*)segue.destinationViewController;
        w.url = self.story.origURL;
        w.contentTitle = self.story.title;
    }
}

//-(void)enableButtonsIfUserLoggedIn {
//    if (self.currentUser.isLoggedIn){
//        self.recollectButton.alpha = 1.0f;
//        self.recollectButton.enabled = YES;
//        
//        self.upVoteButton.alpha = 1.0f;
//        self.upVoteButton.enabled = YES;
//        
//        self.downVoteButton.alpha = 1.0f;
//        self.downVoteButton.enabled = YES;
//    }
//}

-(void)popupAlertIfUserNotLoggedIn {
    [collectivlyUtilities createAndShowDismissableAlertviewWithTitle:@"Not Logged In"
                                                              andMessage:@"You must be logged in for that!"];
}


#pragma mark - cleanup
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
