//
//  collectivlyCollectionsViewController.m
//  collectivly
//
//  Created by Nathan Fraenkel on 4/6/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import "collectivlyCollectionsViewController.h"

#define COLLECTIONINBETWEEN     7
#define COLLECTIONBGALPHA       0.7f
#define SCROLLVIEWPADDING       20

@interface collectivlyCollectionsViewController ()

@end

@implementation collectivlyCollectionsViewController

@synthesize collectionsTableView, currentUser, HUD, rightSideBarViewController, refresherController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - VIEW STUFF
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"[collectivlyCollectionsViewController] viewdidload");
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topbar_320x44.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(fetchRelevantCollections) forControlEvents:UIControlEventValueChanged];
    [refreshControl setTintColor:[UIColor magentaColor]];
    [self.collectionsTableView addSubview:refreshControl];
    self.refresherController = refreshControl;
    self.refresherController.enabled = NO;
    
    self.currentUser = [collectivlySingleton sharedDataModel];
    
    [self setUpNavBar];
}


-(void)viewDidAppear:(BOOL)animated {
    NSLog(@"[collectivlyCollectionsViewController] viewdidappear");
    // update log in button, fetch collections
    [self refreshView];
}

-(void)refreshView {
    [self fetchRelevantCollections];
}

#pragma mark nav bar and button items related
-(void)setUpNavBar {
    
    // customize LEFT / BACK bar button item
    UIImage* logo = [UIImage imageNamed:@"logo.png"];
    NSInteger logoOffset = 28;
    CGRect logoframe = CGRectMake(logoOffset*4, logoOffset, logo.size.width - logoOffset, logo.size.height - logoOffset);
    UIButton *logoButton = [[UIButton alloc] initWithFrame:logoframe];
//    logoButton.userInteractionEnabled = NO;
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
    
    // customize nav bar label text
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"ProximaNova-Light" size:20];
    //    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    //    label.textAlignment = UITextAlignmentCenter;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor =[UIColor whiteColor];
    label.text = @"COLLECTIONS";
    self.navigationItem.titleView = label;
    
    // set up delegate for sidebar actions
    self.navigationItem.revealSidebarDelegate = self;
}

-(IBAction)leftBarButtonItemTouched:(id)sender {
    [self performSegueWithIdentifier:@"loginsignup" sender:self];
}

- (IBAction)rightSideBarButtonTouched:(id)sender {
    NSLog(@"[collectivlyCollectionsViewController] right side bar touched");
    [self.navigationController toggleRevealState:JTRevealedStateRight];
}

#pragma mark - SIDEBAR
#pragma mark SidebarViewControllerDelegate

- (void)sidebarViewController:(collectivlySidebarViewController *)sidebarViewController didSelectObject:(NSObject *)object atIndexPath:(NSIndexPath *)indexPath {
    
    [sidebarViewController.table deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.navigationController setRevealedState:JTRevealedStateNo];

    NSLog(@"[collectivlyCollectionsViewController] SIDEBARRRRRR DIDSELECTOBJECT: %@", object.description);
    if ([object isKindOfClass:[NSString class]]){
        NSString *string = (NSString *)object;
        if ([string isEqualToString:@"Login"]){
            [self performSegueWithIdentifier:@"loginsignup" sender:self];
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

#pragma mark - TABLE VIEW STUFF
#pragma mark table view delegate methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    collectivlyCollection *cc = [self.currentUser.collections objectAtIndex:indexPath.row];
    [self getStoriesForCollection:cc];
}

#pragma mark table source methods
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.currentUser.collections == nil)
        return nil;
    
    static NSString *collectionCellIdentifier = @"collectionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:collectionCellIdentifier forIndexPath:indexPath];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:collectionCellIdentifier];
    
    collectivlyCollection *cc = [self.currentUser.collections objectAtIndex:indexPath.row];

    UIImageView *collectionImage = (UIImageView *)[cell viewWithTag:10];
    
    UILabel *title = (UILabel*)[cell viewWithTag:100];
    title.font = [UIFont fontWithName:@"ProximaNova-Light" size:21];
    title.text = cc.name.uppercaseString;
    collectionImage.image = cc.image;

    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentUser.collections.count;
}

-(void)populateDisplayWithStories:(NSArray*)storyz {
    // update current stuff for singleton
    [self.currentUser setStories:storyz];
    selectedCollection = -1;
    
    // show collection!
    [self performSegueWithIdentifier:@"showCollection" sender:self];
}

#pragma mark - COMMAND execution
-(void)getStoriesForCollection:(collectivlyCollection *)collection {
    
    self.currentUser.currentCollection = collection;
    selectedCollection = collection.idNumber;
    
    BOOL alreadyStoriesForThatCollection = [self.currentUser.storiesForCollectionWithId objectForKey:[NSString stringWithFormat:@"%d", selectedCollection]] != nil;
    
    if (alreadyStoriesForThatCollection){
        NSLog(@"[collectivlyCollectionsViewController] GETTING OLD STORIES!!! FOR COLLECTION ID: %d WITH TITLE: %@", collection.idNumber, collection.name);
        
        // get stories
        NSMutableArray *stories = [self.currentUser.storiesForCollectionWithId objectForKey:[NSString stringWithFormat:@"%d", selectedCollection]];
        
        [self populateDisplayWithStories:stories];

    }
    
    // OTHERWISE: fetch collection via network
    else {
        NSLog(@"[collectivlyCollectionsViewController] GETTING NEW STORIES!!! FOR COLLECTIN ID: %d WITH TITLE: %@", collection.idNumber, collection.name);
        
        // spinnaz
        HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        HUD.delegate = self;
        HUD.labelText = @"Loading Stories";
        
        GetStoriesForCollectionCommand *cmd = [[GetStoriesForCollectionCommand alloc] initWithCollection:collection andPageNumber:1];
        cmd.delegate = self;
        [cmd fetchStoriesForCollectionFromPage];
    }
}

-(void)fetchRelevantCollections {
    HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
	HUD.delegate = self;
	HUD.labelText = @"Loading";
    
    GetCollectionsCommand *cmd = [[GetCollectionsCommand alloc] initWithUserAlreadyLoggedInBool:self.currentUser.isLoggedIn];
    cmd.delegate = self;
    [cmd fetchCollections];
}

#pragma mark - COMMAND DELEGATES for data retrieval
#pragma mark Get Collections
-(void)reactToGetCollectionsResponse:(NSArray *)collections {
    
    self.currentUser.collections = collections;
    
    [self.collectionsTableView reloadData];

    [HUD hide:YES];
    if (!self.refresherController.enabled)
        self.refresherController.enabled = YES;
    [self.refresherController endRefreshing];
}

-(void)reactToGetCollectionsError:(NSError *)error {
    [HUD hide:YES];
    if (!self.refresherController.enabled)
        self.refresherController.enabled = YES;
    [self.refresherController endRefreshing];
}

#pragma mark Get Stories For Collection
-(void)reactToGetStoriesResponse:(NSArray *)stories {
    // UPDATE STORIES DICTIONARY IN SINGLETON
    if (self.currentUser.currentCollection != nil) {
        if (self.currentUser.storiesForCollectionWithId == nil) {
            self.currentUser.storiesForCollectionWithId = [[NSMutableDictionary alloc] initWithObjectsAndKeys:stories, [NSString stringWithFormat:@"%d", selectedCollection], nil];        }
        else {
            [self.currentUser.storiesForCollectionWithId setObject:stories forKey:[NSString stringWithFormat:@"%d", selectedCollection]];
        }
        
    }
    
    [HUD hide:YES];
    
    [self populateDisplayWithStories:stories];

}
-(void)reactToGetStoriesError:(NSError *)error {
    [HUD hide:YES];
    if (!self.refresherController.enabled)
        self.refresherController.enabled = YES;
    [self.refresherController endRefreshing];
}

#pragma mark - cleanup
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
