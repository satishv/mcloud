//
//  collectivlyCollectionsViewController.m
//  collectivly
//
//  Created by Nathan Fraenkel on 4/6/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import "collectivlyCollectionsViewController.h"

#define REQUESTHOMEPAGE         1
#define GETCOLLECTIONS          2
#define GETCERTAINCOLLECTION    3

#define COLLECTIONINBETWEEN     7
#define COLLECTIONBGALPHA       0.7f
#define SCROLLVIEWPADDING       20

@interface collectivlyCollectionsViewController ()

@end

@implementation collectivlyCollectionsViewController

NSInteger selectedCollection;

@synthesize collectionsTableView, currentUser, HUD, rightSideBarViewController, refresherController;

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

    // request number 0 initially
    requestNumber = 0;
        
    self.currentUser = [collectivlySingleton sharedDataModel];
    self.currentUser.authToken = @"";
    
    self.collectionsTableView.delegate = self;
    self.collectionsTableView.dataSource = self;
    
    [self setUpNavBar];
    
    NSLog(@"COLLECTIVLY COOKIEs: %@ ", [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]);

}


-(void)viewDidAppear:(BOOL)animated {
    NSLog(@"[collectivlyCollectionsViewController] viewdidappear");
    // update log in button, fetch collections
    [self refreshView];
}

-(void)refreshView {
    [self fetchRelevantCollections];
    //    [self checkForCookiesAndSession];
}

#pragma mark helpers
-(NSMutableArray *)createStoriesFromResponse:(NSArray*)array {
    NSLog(@"[collectivlyCollectionsViewController] creating stories from array.");
    NSMutableArray *stories = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; i++){
        NSLog(@"[collectivlyCollectionsViewController] STORYYY %d out of %d", i, array.count);
        collectivlySimplifiedStory *story = [[collectivlySimplifiedStory alloc] initWithDictionary:[array objectAtIndex:i]];
        NSLog(@"[collectivlyCollectionsViewController] STORYYY %d out of %d DONE", i, array.count);
        [stories addObject:story];
        
    }
    NSLog(@"[collectivlyCollectionsViewController] DONE creating stories from array.");
    return stories;
}

-(NSString*)extractAuthToken:(NSString *)string {
    
    NSRange range = [string rangeOfString:@"authenticity_token\" type=\"hidden\" value=\""];
    NSString *auth = [[string substringWithRange:NSMakeRange(range.location + range.length, 44)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"AUTH TOKEN: %@", auth);
    return auth;
}


-(BOOL)someoneIsLoggedIn{
    return (self.currentUser.isLoggedIn);
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

#pragma mark HTTP requests
-(void)getStoriesForCollection:(collectivlyCollection *)collection {
    
    self.currentUser.currentCollection = collection;
    selectedCollection = collection.idNumber;
    
    // IF collection has already been clicked and cached: just get it from data structure
    // instead of fetching again via same network call
    if ([[self.currentUser.storiesForCollectionWithId objectForKey:[NSString stringWithFormat:@"%d", collection.idNumber]] isKindOfClass:[NSMutableArray class]]){
        NSLog(@"[collectivlyCollectionsViewController] GETTING OLD STORIES!!! FOR COLLECTION ID: %d WITH TITLE: %@", collection.idNumber, collection.name);
        
        // get stories
        NSMutableArray *stories = [self.currentUser.storiesForCollectionWithId objectForKey:[NSString stringWithFormat:@"%d", collection.idNumber]];
        
        // update current stuff for singleton
        [self.currentUser setCurrentStories:stories];
        selectedCollection = -1;
        
        // show collection! 
        [self performSegueWithIdentifier:@"showCollection" sender:self];
    }
    
    // OTHERWISE: fetch collection via network
    else {
        NSLog(@"[collectivlyCollectionsViewController] GETTING NEW STORIES!!! FOR COLLECTIN ID: %d WITH TITLE: %@", collection.idNumber, collection.name);
        
        // spinnaz
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        HUD.delegate = self;
        HUD.labelText = @"Loading";
        
//        NSLog(@"id: %d", collection.idNumber);
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://collectivly.com/stories/everyone/%d.json?page=1", collection.idNumber]];
        
//        NSLog(@"\"%@\"", url);
        
        NSLog(@"[collectivlyCollectionsViewController] fetching stories for collection with id: %d and name: %@", collection.idNumber, collection.name);
        
        // HTTP request, setting stuff
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        // SET REQUEST NUMBER TO APPROPRIATE VALUE
        requestNumber = GETCERTAINCOLLECTION;
        
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [connection start];
    }
}


//-(void)checkForCookiesAndSession {
//    NSLog(@"COOKIES????????/");
//    
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    NSString *url = @"https://collectivly.com/stories/count.json";
//    
//    // HTTP request, setting stuff
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
//    [request setHTTPMethod:@"GET"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    
//    // SET REQUEST NUMBER TO APPROPRIATE VALUE
//    requestNumber = 100;
//    
//    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    [connection start];
//}

-(void)fetchRelevantCollections {
    NSLog(@"fetching relevant collections.....");

    // spinnaz
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
   	HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
	HUD.delegate = self;
	HUD.labelText = @"Loading";

    // set URL
    NSString *url = @"";
    // TODO: once implemented, add different link for signed in person
    if ([self someoneIsLoggedIn]){
        NSLog(@"[collectivlyCollectionsViewController] SOMEONE LOGGED IN --> personalized collections!");
        url = @"https://www.collectivly.com/clubb.json";
    }
    else {
        NSLog(@"[collectivlyCollectionsViewController] NO ONE LOGGED IN --> popular collections!");
        url = @"https://www.collectivly.com/clubb.json";
    }
    
    // HTTP request, setting stuff
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.timeoutInterval = 10;

    // SET REQUEST NUMBER TO APPROPRIATE VALUE
    requestNumber = GETCOLLECTIONS;
    
    // start connection
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

-(void)requestHomePage {
    NSLog(@"[collectivlyCollectionsViewController] HOME PAGE!!!");
    
    HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
	
	HUD.delegate = self;
	HUD.labelText = @"Loading";

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *url = @"https://collectivly.com/";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    // HTTP request, setting stuff
    [request setHTTPMethod:@"GET"];
    
    // SET REQUEST NUMBER TO APPROPRIATE VALUE
    requestNumber = REQUESTHOMEPAGE;
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    
}

#pragma mark connection protocol functions
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"[collectivlyCollectionsViewController] conection did receive response!");
    _data = [[NSMutableData alloc] init];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"[collectivlyCollectionsViewController] conection did receive data!");
    [_data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // Please do something sensible here, like log the error.
    NSLog(@"[collectivlyCollectionsViewController] connection failed with error: %@", error.description);
    
    // stop spinners
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [HUD hide:YES];
    [self.refresherController endRefreshing];
    
    // alert view for network error
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Network Error"
                          message: @"There was a network error :\\"
                          delegate: self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"Retry", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:
            if (requestNumber == REQUESTHOMEPAGE){
                [self requestHomePage];
            }
            else if (requestNumber == GETCOLLECTIONS){
                [self fetchRelevantCollections];
            }
            else if (requestNumber == GETCERTAINCOLLECTION){
                // TODO
                [self getStoriesForCollection:self.currentUser.currentCollection];
            }
            break;
        default:
            break;
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"[collectivlyCollectionsViewController] connectiondidfinishloading!");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSString *responseString = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
//    NSLog(@"response data: %@", responseString);
    
    NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
    
    // act based on what the request was (requestinvite, requestsignin, etc)
    switch (requestNumber)
    {
        case REQUESTHOMEPAGE: {
            // SET auth token
            self.currentUser.authToken = [self extractAuthToken:responseString];
            break;
        }
        case GETCOLLECTIONS: {
            
            float contentHeight = SCROLLVIEWPADDING;

//            NSLog(@"[collectivlyCollectionsViewController] DICT RESPONSE FOR COLLECTTIONSS: %@", dictResponse);
            NSMutableArray *colls = [[NSMutableArray alloc] init];
            // counter            
            for (NSDictionary *dict in dictResponse){
                collectivlyCollection *cc = [[collectivlyCollection alloc] initWithDictionary:dict];
                
                // add collection to list of collections
//                NSLog(@"[collectivlyCollectionsViewController] ADDINGGNGGGG collection with id: %d", cc.idNumber);
                [colls addObject:cc];
            }
            // TODO: update...? shouldn't automatically be popular collections
            self.currentUser.collections = colls;
            
            [self.collectionsTableView reloadData];
                        
            [HUD hide:YES];
            if (!self.refresherController.enabled)
                self.refresherController.enabled = YES;
            [self.refresherController endRefreshing];
            
            break;
        }
        case GETCERTAINCOLLECTION: {
//            NSLog(@"[collectivlyCollectionsViewController] CERTAIN COLLECTION WITH RESPONSE: %@", dictResponse);
            
            NSMutableArray *stories = [[NSMutableArray alloc] init];
            
            NSArray *array = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
            
            
            // stories for the relevant collection!
            stories = [self createStoriesFromResponse:array];
            
            // UPDATE STORIES DICTIONARY IN SINGLETON 
            if (self.currentUser.currentCollection != nil) {
//                NSLog(@"[collectivlyCollectionsViewController] ADDING A GUY for this collection: %d", selectedCollection);
                
                // update singleton dictionary of stories for a collection
                if (self.currentUser.storiesForCollectionWithId == nil) {
                    self.currentUser.storiesForCollectionWithId = [[NSMutableDictionary alloc] initWithObjectsAndKeys:stories, [NSString stringWithFormat:@"%d", selectedCollection], nil];
                }
                else {
                    [self.currentUser.storiesForCollectionWithId setObject:stories forKey:[NSString stringWithFormat:@"%d", selectedCollection]];
                }
//                NSLog(@"[collectivlyCollectionsViewController] storiesforcollectionwithid: %@", self.currentUser.storiesForCollectionWithId);
                [self.currentUser setCurrentStories:stories];
            }
            selectedCollection = -1;
            
            [HUD hide:YES];
            
            // SHOW COLLECTOIN ITSELF AND ITS STORIES!
            [self performSegueWithIdentifier:@"showCollection" sender:self];
            break;
        }
//        case 100:
//            NSLog(@"COOKES: %@", dictResponse);
//            [HUD hide:YES];
//            
//            [self.refresherController endRefreshing];
//            break;
        default:
            break;
    }
    
}

#pragma mark cleanup
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
