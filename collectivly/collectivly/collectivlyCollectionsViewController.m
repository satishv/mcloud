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

@synthesize scrolley, currentUser, rightSideBarViewController, firstCollectionImage, firstTitle, HUD;

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

    // request number 0 initially
    requestNumber = 0;
    
    self.scrolley.delegate = self;
    
    self.currentUser = [collectivlySingleton sharedDataModel];
    self.currentUser.authToken = @"";
    
    // clear all collection images
    firstTitle.text = @"";
    
    firstCollectionImage.alpha = 0.0f;
    
    [self setUpNavBar];
}

-(void)setUpNavBar {
    
    // customize LEFT / BACK bar button item
    UIImage* logo = [UIImage imageNamed:@"logo.png"];
    NSInteger logoOffset = 28;
    CGRect logoframe = CGRectMake(logoOffset*4, logoOffset, logo.size.width - logoOffset, logo.size.height - logoOffset);
    UIButton *logoButton = [[UIButton alloc] initWithFrame:logoframe];
    logoButton.userInteractionEnabled = NO;
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
    label.font = [UIFont fontWithName:@"ProximaNova-Bold" size:16];
    //    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    //    label.textAlignment = UITextAlignmentCenter;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor =[UIColor whiteColor];
    label.text = @"COLLECTIONS";
    self.navigationItem.titleView = label;
    
    // set up delegate for sidebar actions
    self.navigationItem.revealSidebarDelegate = self;
}

- (IBAction)rightSideBarButtonTouched:(id)sender {
    NSLog(@"[collectivlyCollectionsViewController] right side bar touched");
    [self.navigationController toggleRevealState:JTRevealedStateRight];
}

#pragma mark SidebarViewControllerDelegate

- (void)sidebarViewController:(SidebarViewController *)sidebarViewController didSelectObject:(NSObject *)object atIndexPath:(NSIndexPath *)indexPath {
    
    [sidebarViewController.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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


-(void)FirstImageTouched:(id) sender {
    NSLog(@"image 1 has been touched and has liked it");
    
    collectivlyCollection *collection = [self.currentUser.popularCollections objectAtIndex:0];
    [self getStoriesForCollection:collection];
}

-(void)ithImageTouched:(id) sender {
    NSLog(@"image i has been touched and has liked it");
    int i = ithCollectionBG.tag;
    collectivlyCollection *collection = [self.currentUser.popularCollections objectAtIndex:i-1];
    [self getStoriesForCollection:collection];
}

-(void)viewDidAppear:(BOOL)animated {
    NSLog(@"[collectivlyCollectionsViewController] viewdidappear");
    // update log in button, fetch collections
    [self refreshView];
}

-(NSMutableArray *)createStoriesFromResponse:(NSArray*)array {
    NSLog(@"[collectivlyCollectionsViewController] creating stories from array.");
    NSMutableArray *stories = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; i++){
        NSLog(@"[collectivlyCollectionsViewController] STORYYY %d out of %d", i, array.count);
        collectivlyStory *story = [[collectivlyStory alloc] initWithDictionary:[array objectAtIndex:i]];
        NSLog(@"[collectivlyCollectionsViewController] STORYYY %d out of %d DONE", i, array.count);
        [stories addObject:story];
        
    }
    NSLog(@"[collectivlyCollectionsViewController] DONE creating stories from array.");
    return stories;
}

-(void)getStoriesForCollection:(collectivlyCollection *)collection {
        
//    NSLog(@"length of storiesforcollectionwithid: %d", self.currentUser.storiesForCollectionWithId.count);
//    for (NSString *key in self.currentUser.storiesForCollectionWithId){
//        NSLog(@"KEY: %@, and VALUE: %@", key, [self.currentUser.storiesForCollectionWithId objectForKey:key]);
//    }
    
    // IF collection has already been clicked and cached: just get it from data structure
    // instead of fetching again via same network call
    if ([[self.currentUser.storiesForCollectionWithId objectForKey:[NSString stringWithFormat:@"%d", collection.idNumber]] isKindOfClass:[NSMutableArray class]]){
        
        NSLog(@"[collectivlyCollectionsViewController] GETTING OLD STORIES!!! FOR COLLECTION ID: %d WITH TITLE: %@", collection.idNumber, collection.name);
        
        // get stories
        NSMutableArray *stories = [self.currentUser.storiesForCollectionWithId objectForKey:[NSString stringWithFormat:@"%d", collection.idNumber]];
        
        // update current stuff for singleton
        self.currentUser.currentCollection = collection;
        selectedCollection = collection.idNumber;
        [self.currentUser setCurrentStories:stories];
        selectedCollection = -1;
        // show collection! 
        [self performSegueWithIdentifier:@"showCollection" sender:self];
    }
    // OTHERWISE: fetch collection via network
    else {
        NSLog(@"[collectivlyCollectionsViewController] fetching story with id: %d", collection.idNumber);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        NSLog(@"id: %d", collection.idNumber);
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://collectivly.com/stories/everyone/%d.json", collection.idNumber]];
        
        NSLog(@"[collectivlyCollectionsViewController] fetching stories for collection with id: %d and name: %@", collection.idNumber, collection.name);
        
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        // HTTP request, setting stuff
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        // SET REQUEST NUMBER TO APPROPRIATE VALUE
        requestNumber = GETCERTAINCOLLECTION;
        self.currentUser.currentCollection = collection;
        selectedCollection = collection.idNumber;
        
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [connection start];
        
        HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        HUD.delegate = self;
        HUD.labelText = @"Loading";
    }
}

-(NSString*)extractAuthToken:(NSString *)string {
    
    NSRange range = [string rangeOfString:@"authenticity_token"];
    NSString *auth = [[string substringWithRange:NSMakeRange(range.location + range.length + 23, 44)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return auth;
}

-(BOOL)someoneIsLoggedIn{
    return (self.currentUser.isLoggedIn);
}

-(void)refreshView {
    [self fetchRelevantCollections];
}

-(void)fetchRelevantCollections {
    NSLog(@"fetching relevant collections.....");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    

    NSString *url = @"";
    
    if ([self someoneIsLoggedIn]){
        NSLog(@"[collectivlyCollectionsViewController] display collections specific current logged in user!");
        
        url = @"https://collectivly.com/categories.json?order=rank";

    }
    else {
        NSLog(@"[collectivlyCollectionsViewController] display most popular collections, because no one is logged in!");
        
        url = @"https://collectivly.com/categories.json?page=1";
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];

    // HTTP request, setting stuff
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    // SET REQUEST NUMBER TO APPROPRIATE VALUE
    requestNumber = GETCOLLECTIONS;
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    
    
   	HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
	
	HUD.delegate = self;
	HUD.labelText = @"Loading";
    
}


#pragma mark HTTP requests
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
    
    // stop spinner
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    [HUD hide:YES];
    
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
//                [self getStoriesForCollection:self.currentUser];
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

            NSLog(@"[collectivlyCollectionsViewController] DICT RESPONSE FOR COLLECTTIONSS: %@", dictResponse);
            NSMutableArray *colls = [[NSMutableArray alloc] init];
            // counter
            int i = 1;
            
            for (NSDictionary *dict in dictResponse){
                collectivlyCollection *cc = [[collectivlyCollection alloc] initWithDictionary:dict];
                
                NSString *title = cc.name.uppercaseString;
                UIFont *customFont = [UIFont fontWithName:@"ProximaNova-Semibold" size:32];
                
                switch (i) {
                    // for first collection only: use premade UI elements in STORYBOARD
                    case 1 :{
                        [UIView animateWithDuration:0.5f animations:^{
                            firstTitle.text = title;
                            firstTitle.font = customFont;
                            firstCollectionImage.image = cc.image;
                            firstCollectionImage.alpha = COLLECTIONBGALPHA;
                            UITapGestureRecognizer *firstImageViewGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(FirstImageTouched:)];
                            [firstImageViewGestureRecognizer setNumberOfTapsRequired:1];
                            [firstImageViewGestureRecognizer setDelegate:self];
                            
                            self.firstCollectionImage.userInteractionEnabled = YES;
                            [self.firstCollectionImage addGestureRecognizer:firstImageViewGestureRecognizer];
                            
                            NSLog(@"frame for %@: {%f %f %f %f}", cc.name, firstCollectionImage.frame.origin.x, firstCollectionImage.frame.origin.y, firstCollectionImage.frame.size.width, firstCollectionImage.frame.size.height);
                            
                        }];
                        contentHeight += firstCollectionImage.frame.size.height;
                        break;
                    }
                    // ALL i != 1: create all UI elements programatically
                    default: {
                        NSLog(@"in here for i = %d, and collection: %@", i, cc.name);
                        CGFloat y = firstCollectionImage.frame.origin.y + firstCollectionImage.frame.size.height + COLLECTIONINBETWEEN + (i-2)*(firstCollectionImage.frame.size.height + COLLECTIONINBETWEEN);
                        if (ithCollectionBG == nil){
                            ithCollectionBG = [[UIImageView alloc] initWithFrame:CGRectMake(firstCollectionImage.frame.origin.x, y, firstCollectionImage.frame.size.width, firstCollectionImage.frame.size.height)];
    
                        }
                        else {
                            [ithCollectionBG setFrame:CGRectMake(firstCollectionImage.frame.origin.x, y, firstCollectionImage.frame.size.width, firstCollectionImage.frame.size.height)];

                        }
                        ithCollectionBG.image = cc.image;
                        ithCollectionBG.userInteractionEnabled = YES;
                        UILabel *collectionName = [[UILabel alloc] initWithFrame:CGRectMake(ithCollectionBG.frame.origin.x + 18, ithCollectionBG.frame.origin.y + ithCollectionBG.frame.size.height - firstTitle.frame.size.height - 17, self.firstTitle.frame.size.width, self.firstTitle.frame.size.height)];
                        collectionName.text = title;
                        collectionName.font = customFont;
                        collectionName.userInteractionEnabled = NO;
                        collectionName.textColor = [UIColor whiteColor];
                        collectionName.backgroundColor = [UIColor clearColor];
                        ithCollectionBG.alpha = COLLECTIONBGALPHA;
                        UITapGestureRecognizer *imageViewGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ithImageTouched:)];
                        [imageViewGestureRecognizer setNumberOfTapsRequired:1];
                        [imageViewGestureRecognizer setDelegate:self];
                        
                        ithCollectionBG.userInteractionEnabled = YES;
                        ithCollectionBG.tag = i;
                        [ithCollectionBG addGestureRecognizer:imageViewGestureRecognizer];
                        
                        // add to scrollview
                        [self.scrolley addSubview:ithCollectionBG];
                        [self.scrolley addSubview:collectionName];

                        contentHeight += COLLECTIONINBETWEEN + ithCollectionBG.frame.size.height;
                        
                        break;
                    }
                }
                
                // add collection to list of collections
                NSLog(@"[collectivlyCollectionsViewController] ADDINGGNGGGG collection with id: %d", cc.idNumber);
                [colls addObject:cc];
                i++;
            }
            // TODO: update...? shouldn't automatically be popular collections
            self.currentUser.popularCollections = colls;
            
            contentHeight += SCROLLVIEWPADDING;
            [self.scrolley setContentSize:CGSizeMake(self.view.frame.size.width, contentHeight)];
            
            [HUD hide:YES];
            
            break;
        }
        case GETCERTAINCOLLECTION: {
            NSLog(@"[collectivlyCollectionsViewController] CERTAIN COLLECTION WITH RESPONSE: %@", dictResponse);
            
            NSMutableArray *stories = [[NSMutableArray alloc] init];
            
            NSArray *array = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
            
            
            // stories for the relevant collection!
            stories = [self createStoriesFromResponse:array];
//            NSLog(@"[collectivlyCollectionsViewController] STORIES????: %@", stories);
            
            // UPDATE STORIES DICTIONARY IN SINGLETON 
            if (self.currentUser.currentCollection != NULL) {
                NSLog(@"[collectivlyCollectionsViewController] ADDING A GUY for this collection: %d", selectedCollection);
                
                // update singleton dictionary of stories for a collection
                // initil
                if (self.currentUser.storiesForCollectionWithId == nil) {
                    self.currentUser.storiesForCollectionWithId = [[NSMutableDictionary alloc] initWithObjectsAndKeys:stories, [NSString stringWithFormat:@"%d", selectedCollection], nil];
                }
                else {
                    [self.currentUser.storiesForCollectionWithId setObject:stories forKey:[NSString stringWithFormat:@"%d", selectedCollection]];
                }
                NSLog(@"[collectivlyCollectionsViewController] storiesforcollectionwithid: %@", self.currentUser.storiesForCollectionWithId);
                [self.currentUser setCurrentStories:stories];
            }
            selectedCollection = -1;
            
            [HUD hide:YES];
            
            // SHOW COLLECTOIN ITSELF AND ITS STORIES!
            [self performSegueWithIdentifier:@"showCollection" sender:self];
        }
        default:
            break;
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
