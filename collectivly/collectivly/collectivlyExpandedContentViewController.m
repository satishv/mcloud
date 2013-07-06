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

#define REQUESTRECOLLECT    1
#define REQUESTUPVOTE       2
#define REQUESTDOWNVOTE     3

@interface collectivlyExpandedContentViewController ()

@end

@implementation collectivlyExpandedContentViewController

@synthesize currentUser, expandedImageView, story, rightSideBarViewController, totalCountLabel, friendsCountLabel, timeAgoLabel, articleTitleButton, recollectButton, recollected, upVoteButton, upVoted, downVoteButton, downVoted;

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
    
    if (self.story.expandedImage == nil)
        self.story.expandedImage = [self.story imageFromURLString:self.story.expandedImageString];
    if (self.story.image == nil)
        self.story.image = [self.story imageFromURLString:self.story.imageString];

    self.expandedImageView.image = (self.story.expandedImage == nil) ? self.story.image : self.story.expandedImage;
    
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
    
    // check if user logged in or not for BUTTONS
    [self enableButtonsIfUserLoggedIn];
    
    // set up the nav bar, obvi
    [self setUpNavBar];
    
    requestNumber = -1;
    
    NSLog(@"EXPANDEDSTORY: %@", self.story);

}

#pragma nav bar and bar button item setup
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

#pragma mark HTTP requesting
-(void)makeRecollectRequest {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // set up parameters
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    [dataDict setValue:self.currentUser.authToken forKey:@"authenticity_token"];
    [dataDict setValue:[NSString stringWithFormat:@"%d", self.currentUser.currentCollection.idNumber] forKey:@"cl_category"];
    [dataDict setValue:@"" forKey:@"cl_comment"];
    [dataDict setValue:[NSString stringWithFormat:@"%d", self.story.idNumber] forKey:@"story_id"];
    [dataDict setValue:@"1" forKey:@"scope"]; // DEFAULT: 1 = public
    
    NSString *url = @"https://collectivly.com/stories/recloud";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSString *data = [NSString stringWithFormat:@""];
    NSData *postData = ([NSJSONSerialization isValidJSONObject:dataDict]) ? [NSJSONSerialization dataWithJSONObject:dataDict options:NSJSONWritingPrettyPrinted error:nil] : [data dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@", postData);
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    // HTTP request, setting stuff
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody:postData];
    
    // SET REQUEST NUMBER TO APPROPRIATE VALUE
    requestNumber = REQUESTRECOLLECT;
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

-(void)makeUpVoteRequest {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSLog(@"AUTHHHHHHHHH: %@", self.currentUser.authToken);
    // set up parameters
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    [dataDict setValue:@"click" forKey:@"type"];
    [dataDict setValue:[NSString stringWithFormat:@"%d", self.story.idNumber] forKey:@"story_id"];
    [dataDict setValue:@"like" forKey:@"value"];
    [dataDict setValue:self.currentUser.authToken forKey:@"authenticity_token"];
    
    NSString *url = @"https://collectivly.com/stories/recloud";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSString *data = [NSString stringWithFormat:@""];
    NSData *postData = ([NSJSONSerialization isValidJSONObject:dataDict]) ? [NSJSONSerialization dataWithJSONObject:dataDict options:NSJSONWritingPrettyPrinted error:nil] : [data dataUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"%@", postData);
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    // HTTP request, setting stuff
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%@", self.currentUser.authToken] forHTTPHeaderField:@"Authorization"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    // SET REQUEST NUMBER TO APPROPRIATE VALUE
    requestNumber = REQUESTUPVOTE;
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

-(void)makeDownVoteRequest {

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // set up parameters
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    [dataDict setValue:@"click" forKey:@"type"];
    [dataDict setValue:[NSString stringWithFormat:@"%d", self.story.idNumber] forKey:@"story_id"];
    [dataDict setValue:@"un_like" forKey:@"value"];
    [dataDict setValue:self.currentUser.authToken forKey:@"authenticity_token"];
    
    NSString *url = @"https://collectivly.com/stories/recloud";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSString *data = [NSString stringWithFormat:@""];
    NSData *postData = ([NSJSONSerialization isValidJSONObject:dataDict]) ? [NSJSONSerialization dataWithJSONObject:dataDict options:NSJSONWritingPrettyPrinted error:nil] : [data dataUsingEncoding:NSUTF8StringEncoding];
    //    NSLog(@"%@", postData);
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    // HTTP request, setting stuff
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    // SET REQUEST NUMBER TO APPROPRIATE VALUE
    requestNumber = REQUESTDOWNVOTE;
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    
}


#pragma mark connection protocol functions
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"conection did receive response!");
    _data = [[NSMutableData alloc] init];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"conection did receive data!");
    [_data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // Please do something sensible here, like log the error.
    NSLog(@"connection failed with error: %@", error.description);
    
    // stop spinner
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // alert view for network error
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Network Error"
                          message: @"There was a network error :\\"
                          delegate: self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"Retry", nil];
    [alert show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectiondidfinishloading!");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSString *responseString = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
    NSLog(@"response data: %@", responseString);
    
    NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];

    UIAlertView *alert;
    // act based on what the request was
    switch (requestNumber)
    {
        case REQUESTRECOLLECT:
            alert = [[UIAlertView alloc]
                                  initWithTitle: @"Success!"
                                  message: @"RECOLLECT"
                                  delegate: self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            break;
        case REQUESTUPVOTE:
            alert = [[UIAlertView alloc]
                     initWithTitle: @"Success!"
                     message: @"up"
                     delegate: self
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil];
            [alert show];
            break;
        case REQUESTDOWNVOTE:
            alert = [[UIAlertView alloc]
                     initWithTitle: @"Success!"
                     message: @"down"
                     delegate: self
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil];
            [alert show];
            break;
        default:
            break;
    }
    
}

#pragma mark IBActions / button touch recognizers

- (IBAction)centerRecollectButtonTouched:(id)sender {
    NSLog(@"!!!!!!!!!! RECOLLECT !!!!!!!!!!");
    if (!recollected){
        self.recollected = YES;
        [self.recollectButton setImage:[UIImage imageNamed:@"centerrecollectbuttononclick.png"] forState:UIControlStateNormal];
        self.recollectButton.userInteractionEnabled = NO;
        // TODO: actual recollect action stuff
        
        [self makeRecollectRequest];
        
        //
    }
    
}

- (IBAction)downVoteButtonTouched:(id)sender {
    NSLog(@"!!!!!!!!!! DOWNVOTE !!!!!!!!!!");
    if (!downVoted){
        self.downVoted = YES;
        [self.downVoteButton setImage:[UIImage imageNamed:@"downvoteonclick.png"] forState:UIControlStateNormal];
        self.downVoteButton.userInteractionEnabled = NO;
        // TODO: actual downvote action stuff
        
        [self makeDownVoteRequest];
        
        //
        if (upVoted){
            self.upVoted = NO;
            [self.upVoteButton setImage:[UIImage imageNamed:@"upvote.png"] forState:UIControlStateNormal];
            self.upVoteButton.userInteractionEnabled = YES;
        }
    }
    
    
}

- (IBAction)upVoteButtonTouched:(id)sender {
    NSLog(@"!!!!!!!!!! UPVOTE !!!!!!!!!!");
    if (!upVoted){
        self.upVoted = YES;
        [self.upVoteButton setImage:[UIImage imageNamed:@"upvoteonclick.png"] forState:UIControlStateNormal];
        self.upVoteButton.userInteractionEnabled = NO;
        // TODO: actual upvote action stuff
        
        [self makeUpVoteRequest];
        
        //
        if (downVoted){
            self.downVoted = NO;
            [self.downVoteButton setImage:[UIImage imageNamed:@"downvote.png"] forState:UIControlStateNormal];
            self.downVoteButton.userInteractionEnabled = YES;
        }
    }
    
}

- (IBAction)articleTitleTouched:(id)sender {
    NSLog(@"!!!!!!!!!! TOUCHED ARTICLE TITLE !!!!!!!!!!");
    NSLog(@"title: %@", self.articleTitleButton.titleLabel.text);
    
    NSLog(@"url to go to: %@", self.story.origURL);
    
    [self performSegueWithIdentifier:@"showWebView" sender:self];
    
//    [[UIApplication sharedApplication] openURL:self.story.origURL];
}

#pragma mark helpers
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showWebView"]) {
        collectivlyWebViewController *w = (collectivlyWebViewController*)segue.destinationViewController;
        w.url = self.story.origURL;
        w.contentTitle = self.story.title;
    }
}

-(void)enableButtonsIfUserLoggedIn {
    if (self.currentUser.isLoggedIn){
        self.recollectButton.alpha = 1.0f;
        self.recollectButton.enabled = YES;
        
        self.upVoteButton.alpha = 1.0f;
        self.upVoteButton.enabled = YES;
        
        self.downVoteButton.alpha = 1.0f;
        self.downVoteButton.enabled = YES;
    }
}

#pragma mark cleanup
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
