//
//  collectivlyStoriesViewController.m
//  collectivly
//
//  Created by Nathan Fraenkel on 4/19/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import "collectivlyStoriesViewController.h"

#define INITIALSTORYPAGENUMBER      1

@interface collectivlyStoriesViewController ()

@end

@implementation collectivlyStoriesViewController

@synthesize currentUser, stories, rightSideBarViewController, activityIndicatorForLoadingMoreStories;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization

        
    }
    return self;
}

#pragma mark - VIEW STUFF
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"[collectivlyStoriesViewController] viewdidload");
    
    pageOfStories = INITIALSTORYPAGENUMBER;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshStoriesTable) forControlEvents:UIControlEventValueChanged];
    [refreshControl setTintColor:[UIColor magentaColor]];
    self.refreshControl = refreshControl;
    
    // add background behind tableview
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cream_pixels.png"]];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    self.currentUser = [collectivlySingleton sharedDataModel];
        
    self.stories = [NSMutableArray arrayWithArray:self.currentUser.stories];
    NSLog(@"stories for id %d: %@", self.currentUser.currentCollection.idNumber, self.stories);
    
    // SET UP NAV BAR
    [self setUpNavBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageDoneLoadingFromAsyncImageView:) name:AsyncImageLoadDidFinish object:nil];

}

-(void)imageDoneLoadingFromAsyncImageView:(NSNotification*)notif {
    AsyncImageView *async = notif.object;
    collectivlyStory *cStory = async.cStory;
    cStory.articleImage = [notif.userInfo objectForKey:AsyncImageImageKey];
} 

#pragma mark nav bar customization
-(void)setUpNavBar {
    
    NSLog(@"[collectivlyStoriesViewController] setting up nav bar");
    
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
    label.font = [UIFont fontWithName:APP_FONT_BOLD size:16];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor =[UIColor whiteColor];
    label.text = [[NSString stringWithFormat:@"%@", self.currentUser.currentCollection.name] uppercaseString];
    self.navigationItem.titleView = label;
    
    // set side bar view delegate
    self.navigationItem.revealSidebarDelegate = self;
    
    NSLog(@"[collectivlyStoriesViewController] DONE setting up nav bar");
}

- (IBAction)rightSideBarButtonTouched:(id)sender {
    NSLog(@"[collectivlyStoriesViewController] OPTIONS MENU touched");
    [self.rightSideBarViewController updateUserNameDisplay];
    [self.navigationController toggleRevealState:JTRevealedStateRight];
}

- (IBAction)leftBarButtonItemTouched:(id)sender {
    NSLog(@"[collectivlyStoriesViewController] BACK BUTTON / COLLECTIVLY LOGO HIT for collection: %@", self.title);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - SIDEBAR
#pragma mark SidebarViewControllerDelegate
- (void)didSelectLoginSignUpButton {
    [self.navigationController toggleRevealState:JTRevealedStateRight];
    UIViewController *loginNav = [self.storyboard instantiateViewControllerWithIdentifier:@"loginSignUpNavController"];
    [self.navigationController presentViewController:loginNav animated:YES completion:^{
        //
    }];
}

- (void)sidebarViewController:(collectivlySidebarViewController *)sidebarViewController didSelectObject:(NSObject *)object atIndexPath:(NSIndexPath *)indexPath {
    
    [sidebarViewController.table deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.navigationController setRevealedState:JTRevealedStateNo];

    
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
-(void)refreshStoriesTable {
    NSLog(@"[collectivlyStoriesViewController] REFRESHING STORIES");
    
    // reset page number
    pageOfStories = INITIALSTORYPAGENUMBER;
    
    // get stories for page 1!
    [self fetchStoriesForPage:INITIALSTORYPAGENUMBER];
}

-(void)fetchStoriesForPage:(NSInteger)page {
    NSLog(@"[collectivlyStoriesViewController] STORIES for page %d", page);
    
    GetStoriesForCollectionCommand *cmd = [[GetStoriesForCollectionCommand alloc] initWithCollection:self.currentUser.currentCollection andPageNumber:page];
    cmd.delegate = self;
    [cmd fetchStoriesForCollectionFromPage];
}

#pragma mark - COMMAND DELEGATES
#pragma mark Get Stories For Collection
-(void)reactToGetStoriesResponse:(NSArray *)newStories {
    [self.refreshControl endRefreshing];
    
    if (self.activityIndicatorForLoadingMoreStories != nil){
        [self.activityIndicatorForLoadingMoreStories stopAnimating];
    }
    
    if (newStories.count < 5)
        hasReachedTheEnd = YES;
    
    if (self.currentUser.currentCollection != nil) {
        // update singleton dictionary of stories for a collection
        if (pageOfStories == INITIALSTORYPAGENUMBER){
            self.stories = [NSMutableArray arrayWithArray:newStories];
        }
        else {
            [self.stories addObjectsFromArray:newStories];
        }
        [self.currentUser setStories:self.stories];
        [self.currentUser.storiesForCollectionWithId setObject:self.stories forKey:[NSString stringWithFormat:@"%d", self.currentUser.currentCollection.idNumber]];
    }
    
    [self.tableView reloadData];
    
    self.tableView.userInteractionEnabled = YES;
}
-(void)reactToGetStoriesError:(NSError *)error {
    [self.refreshControl endRefreshing];
}


#pragma mark - TABLE VIEW STUFF
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.stories.count + 1; // ONE FOR REFRESH CELL
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.stories.count) {
        
        if (self.stories.count < 5 || hasReachedTheEnd) {
            // Configure the cell...
            static NSString *CellIdentifier = @"endCell";
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            return cell;
        }
        else {
            // Configure the cell...
            static NSString *CellIdentifier = @"loadMoreCell";
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            self.activityIndicatorForLoadingMoreStories = (UIActivityIndicatorView*)[cell viewWithTag:100];
            [self.activityIndicatorForLoadingMoreStories startAnimating];
            
            [self fetchStoriesForPage:++pageOfStories];
            return cell;

        }
    }
    
    // set up fonts
    UIFont *customFont = [UIFont fontWithName:APP_FONT_COND_SEMI size:17];
    UIFont *smallCustomFont = [UIFont fontWithName:APP_FONT_COND_REG size:11.5];
    
    // get current time --> convert to GMT time zone time
    NSDate *currentTime = [NSDate date];
    NSString *currentGMTTime = [self convertToGMTTime:currentTime];
    
    // Configure the cell...
    static NSString *CellIdentifier = @"StoryCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    collectivlyStory *story = [self.stories objectAtIndex:indexPath.row];
    NSLog(@"story number %d: %@", indexPath.row, story.title);
    AsyncImageView *storyImageView = (AsyncImageView *)[cell viewWithTag:100];
    if (story.articleImage != nil) {
        [storyImageView setLoadedImage:story.articleImage];
    }
    else {
        storyImageView.cStory = story;
        [storyImageView setImage:[UIImage imageNamed:@"white_square.png"]];
        [storyImageView setImageURL:[NSURL URLWithString:story.articleImageString]];        
    }
    
    UILabel *storyNameLabel = (UILabel *)[cell viewWithTag:101];
    storyNameLabel.text = story.title;
    storyNameLabel.font = customFont;
    
    AsyncImageView *sourceImage = (AsyncImageView *)[cell viewWithTag:102];
    [sourceImage setImage:[UIImage imageNamed:@"white_square.png"]];
    [sourceImage setImageURL:[NSURL URLWithString:story.profileImageString]];
    
    // extract time difference between current time and post time, output time difference to UI
    NSString *timeDifference = [self findDifferenceBetweenCurrent:currentGMTTime AndCreatedTime:story.createdAt];
    story.timeAgo = timeDifference;
    
    UILabel *timeAgoLabel = (UILabel *)[cell viewWithTag:103];
//    timeAgoLabel.text = @"10 seconds ago";
    timeAgoLabel.text = timeDifference;
    timeAgoLabel.font = smallCustomFont;
    
    UILabel *totalCountLabel = (UILabel *)[cell viewWithTag:104];
    totalCountLabel.text = [NSString stringWithFormat:@"%d", story.totalCount];
//    totalCountLabel.text = @"1205";
    totalCountLabel.font = smallCustomFont;
    
    UILabel *friendsCountLabel = (UILabel *)[cell viewWithTag:105];
    friendsCountLabel.text = [NSString stringWithFormat:@"%d", story.friendsCount];
//    friendsCountLabel.text = @"15";
    friendsCountLabel.font = smallCustomFont;
    
    return cell;
}

#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
//    collectivlyExpandedContentViewController *detailViewController = [[collectivlyExpandedContentViewController alloc] initWithNibName:@"collectivlyExpandedContentViewController" bundle:nil];
    collectivlyStory *selected = [self.stories objectAtIndex:indexPath.row];
    [self.currentUser setCurrentStory:selected];
    NSLog(@"selected story title: %@", selected.title);
    // ...
     // Pass the selected object to the new view controller.
//     [self.navigationController pushViewController:detailViewController animated:YES];
    [self performSegueWithIdentifier:@"pushexpandedstory" sender:self];
}

#pragma helpers

-(NSString *)convertToGMTTime:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss'Z'"];
    NSString *resultString = [dateFormatter stringFromDate:date];
    NSTimeZone *currentZone = [NSTimeZone localTimeZone];
    NSInteger diff = [currentZone secondsFromGMT];
    NSInteger hoursFromGMT = diff / 60 / 60;
    
    // convert current time to GMT TIME
    NSInteger currentHour = atoi([[resultString substringWithRange:NSMakeRange(11, 2)] UTF8String]);
    NSInteger currentDay  = atoi([[resultString substringWithRange:NSMakeRange(8, 2)] UTF8String]);
    NSInteger hourGMTadjust = currentHour - hoursFromGMT;
    if (hourGMTadjust > 23) {
        hourGMTadjust -= 24;
        currentDay += 1;
    }
    
    // make new GMT time!
    NSString *currentGMTTime = [NSString stringWithFormat:@"%@%dT%d%@", [resultString substringToIndex:8], currentDay, hourGMTadjust, [resultString substringFromIndex:13]];
    
    return currentGMTTime;
}

-(NSString *)findDifferenceBetweenCurrent:(NSString *)current AndCreatedTime:(NSString *)created {
    if (current.length < created.length){
        NSMutableString *mutableGuy = [NSMutableString stringWithString:current];
        NSString *tee = [mutableGuy substringWithRange:NSMakeRange(9, 1)];
        if ([tee isEqualToString:@"T"]){
            [mutableGuy insertString:@"0" atIndex:8];
        }
        if (mutableGuy.length < created.length) {
            [mutableGuy insertString:@"0" atIndex:11];
        }
        current = [NSString stringWithString:mutableGuy];
    }
    
    NSInteger createdYear = atoi([[created substringWithRange:NSMakeRange(0, 4)] UTF8String]);
    NSInteger currentYear  = atoi([[current substringWithRange:NSMakeRange(0, 4)] UTF8String]);
    
    NSInteger createdMonth = atoi([[created substringWithRange:NSMakeRange(5, 2)] UTF8String]);
    NSInteger currentMonth  = atoi([[current substringWithRange:NSMakeRange(5, 2)] UTF8String]);
    
    NSInteger createdDay = atoi([[created substringWithRange:NSMakeRange(8, 2)] UTF8String]);
    NSInteger currentDay  = atoi([[current substringWithRange:NSMakeRange(8, 2)] UTF8String]);
    
    NSInteger createdHour = atoi([[created substringWithRange:NSMakeRange(11, 2)] UTF8String]);
    NSInteger currentHour  = atoi([[current substringWithRange:NSMakeRange(11, 2)] UTF8String]);
    
    NSInteger createdMinute = atoi([[created substringWithRange:NSMakeRange(14, 2)] UTF8String]);
    NSInteger currentMinute  = atoi([[current substringWithRange:NSMakeRange(14, 2)] UTF8String]);
    
    NSInteger createdSecond = atoi([[created substringWithRange:NSMakeRange(17, 2)] UTF8String]);
    NSInteger currentSecond  = atoi([[current substringWithRange:NSMakeRange(17, 2)] UTF8String]);
    
    if (currentYear - createdYear > 0){
        if (currentYear - createdYear == 1)
            return @"1 year ago";
        else
            return [NSString stringWithFormat:@"%d years ago", currentYear - createdYear];
    }
    else if (currentMonth - createdMonth > 0){
        if (currentMonth - createdMonth == 1)
            return @"1 month ago";
        else
            return [NSString stringWithFormat:@"%d months ago", currentMonth - createdMonth];
    }
    else if (currentDay - createdDay > 0){
        if (currentDay - createdDay == 1)
            return @"1 day ago";
        else
            return [NSString stringWithFormat:@"%d days ago", currentDay - createdDay];
    }
    else if (currentHour - createdHour > 0){
        if (currentHour - createdHour == 1)
            return @"1 hour ago";
        else
            return [NSString stringWithFormat:@"%d hours ago", currentHour - createdHour];
    }
    else if (currentMinute - createdMinute > 0){
        if (currentMinute - createdMinute == 1)
            return @"1 minute ago";
        else
            return [NSString stringWithFormat:@"%d minutes ago", currentMinute - createdMinute];
    }
    else if (currentSecond - createdSecond > 0){
        if (currentSecond - createdSecond == 1)
            return @"1 second ago";
        else
            return [NSString stringWithFormat:@"%d seconds ago", currentSecond - createdSecond];
    }
    else {
        NSLog(@"ERROR in story: current time is %@ while story time is %@", current, created);
        return @"ERROR seconds ago";
    }
}

#pragma mark - cleanup
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
