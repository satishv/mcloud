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
#define COLLECTIONBGALPHA       1.0f

@interface collectivlyCollectionsViewController ()

@end

@implementation collectivlyCollectionsViewController

NSInteger selectedCollection;

@synthesize logInOrOutButton, scrolley, currentUser;
@synthesize firstCollectionBG, firstTitle, secondCollectionBG, secondTitle, thirdCollectionBG, thirdTitle, fourthCollectionBG, fourthTitle;

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
    NSLog(@"[CloudableCollectionsViewController] viewdidload");

    // request number 0 initially
    requestNumber = 0;
    
    self.scrolley.delegate = self;
    
    self.currentUser = [collectivlySingleton sharedDataModel];
    self.currentUser.authToken = @"";
    
    firstTitle.text = @"";
    secondTitle.text = @"";
    thirdTitle.text = @"";
    fourthTitle.text = @"";
    
    firstCollectionBG.alpha = 0.0f;
    secondCollectionBG.alpha = 0.0f;
    thirdCollectionBG.alpha = 0.0f;
    fourthCollectionBG.alpha = 0.0f;
    
    self.activityIndicator.alpha = 0.0f;
}

-(void)FirstImageTouched:(id) sender {
    NSLog(@"image 1 has been touched and has liked it");
    
    collectivlyCollection *collection = [self.currentUser.popularCollections objectAtIndex:0];
    [self getStoriesForCollection:collection];
}

-(void)SecondImageTouched:(id) sender {
    NSLog(@"image 2 has been touched and has liked it");
    collectivlyCollection *collection = [self.currentUser.popularCollections objectAtIndex:1];
    [self getStoriesForCollection:collection];
}

-(void)ThirdImageTouched:(id) sender {
    NSLog(@"image 3 has been touched and has liked it");
    collectivlyCollection *collection = [self.currentUser.popularCollections objectAtIndex:2];
    [self getStoriesForCollection:collection];
}

-(void)FourthImageTouched:(id) sender {
    NSLog(@"image 4 has been touched and has liked it");
    collectivlyCollection *collection = [self.currentUser.popularCollections objectAtIndex:3];
    [self getStoriesForCollection:collection];
}

-(void)ithImageTouched:(id) sender {
    NSLog(@"image i has been touched and has liked it");
    int i = ithCollectionBG.tag;
    collectivlyCollection *collection = [self.currentUser.popularCollections objectAtIndex:i-1];
    [self getStoriesForCollection:collection];
}

-(void)viewDidAppear:(BOOL)animated {
    NSLog(@"[CloudableCollectionsViewController] viewdidappear");
    // update log in button, fetch collections
    [self refreshView];
}

-(NSMutableArray *)createStoriesFromResponse:(NSArray*)array {
    NSMutableArray *stories = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; i++){
        NSLog(@"STORYYY %d: %@", i, [array objectAtIndex:i]);
        collectivlyStory *story = [[collectivlyStory alloc] initWithDictionary:[array objectAtIndex:i]];
        [stories addObject:story];
        
    }
    return stories;
}

-(void)getStoriesForCollection:(collectivlyCollection *)collection {

      NSLog(@"fetching relevant collections.....");
      [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
      
      self.activityIndicator.alpha = 1.0f;
      [self.activityIndicator startAnimating];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://cloudable.me/stories/everyone/11.json"]];
    NSLog(@"id: %d", collection.idNumber);
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://cloudable.me/stories/everyone/%d.json", collection.idNumber]];

    NSLog(@"[CloudableCollectionsViewController] fetching stories for collection with id: %d and name: %@", collection.idNumber, collection.name);

      
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
}

-(NSString*)extractAuthToken:(NSString *)string {
    
    NSRange range = [string rangeOfString:@"authenticity_token"];
    NSString *auth = [[string substringWithRange:NSMakeRange(range.location + range.length + 23, 44)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return auth;
}

-(BOOL)someoneIsLoggedIn{
    return (self.currentUser.isLoggedIn);
}

-(void)updateLogInButtonText {
    if (self.currentUser.isLoggedIn)
        self.logInOrOutButton.titleLabel.text = @"Log Out";
    else
        self.logInOrOutButton.titleLabel.text = @"Log In/Sign up";
}

-(void)refreshView {
    [self updateLogInButtonText];
    
    [self fetchRelevantCollections];
}

-(void)fetchRelevantCollections {
    NSLog(@"fetching relevant collections.....");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    self.activityIndicator.alpha = 1.0f;
    [self.activityIndicator startAnimating];

    NSString *url = @"";
    
    if ([self someoneIsLoggedIn]){
        NSLog(@"[CloudableCollectionsViewController] display collections specific current logged in user!");
        
        url = @"http://cloudable.me/categories.json?order=rank";

    }
    else {
        NSLog(@"[CloudableCollectionsViewController] display most popular collections, because no one is logged in!");
        
        url = @"http://cloudable.me/categories.json?page=1";
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];

    // HTTP request, setting stuff
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    // SET REQUEST NUMBER TO APPROPRIATE VALUE
    requestNumber = GETCOLLECTIONS;
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    
}

- (IBAction)LogInOrOutButtonTouched:(id)sender {
    if (self.currentUser.isLoggedIn){
        // TODO: LOG USER OUT
    }
    else {
        
//        collectivlyViewController *logInViewController = [[collectivlyViewController alloc] init];
        
        [self performSegueWithIdentifier:@"loginsignup" sender:self];
    }
    
}


#pragma mark HTTP requests
-(void)requestHomePage {
    NSLog(@"HOME PAGE!!!");
    
    self.activityIndicator.alpha = 1.0f;
    [self.activityIndicator startAnimating];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *url = @"http://cloudable.me/";
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

    [self.activityIndicator stopAnimating];
    self.activityIndicator.alpha = 0.0f;
    
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
//                [self getStoriesForCollection:self.currentUser];
            }
            break;
        default:
            break;
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectiondidfinishloading!");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.activityIndicator stopAnimating];
    self.activityIndicator.alpha = 0.0f;
    
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

            NSLog(@"DICT RESPONSE FOR COLLECTTIONSS: %@", dictResponse);
            NSMutableArray *colls = [[NSMutableArray alloc] init];
            int i = 1;
            for (NSDictionary *dict in dictResponse){
                collectivlyCollection *cc = [[collectivlyCollection alloc] initWithDictionary:dict];
                
                NSString *title = cc.name.uppercaseString;
                UIFont *customFont = [UIFont fontWithName:@"ProximaNova-Semibold" size:32];
                
                switch (i) {
                    case 1 :{
                        [UIView animateWithDuration:0.5f animations:^{
                            firstTitle.text = title;
                            firstTitle.font = customFont;
                            firstCollectionBG.image = cc.image;
                            firstCollectionBG.alpha = COLLECTIONBGALPHA;
                            UITapGestureRecognizer *firstImageViewGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(FirstImageTouched:)];
                            [firstImageViewGestureRecognizer setNumberOfTapsRequired:1];
                            [firstImageViewGestureRecognizer setDelegate:self];
                            
                            self.firstCollectionBG.userInteractionEnabled = YES;
                            [self.firstCollectionBG addGestureRecognizer:firstImageViewGestureRecognizer];
                        
                        }];
                        break;
                    }
                    case 2 :{
                        [UIView animateWithDuration:0.5f animations:^{
                            secondTitle.text = title;
                            secondTitle.font = customFont;
                            secondCollectionBG.image = cc.image;
                            secondCollectionBG.alpha = COLLECTIONBGALPHA;
                            UITapGestureRecognizer *secondImageViewGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SecondImageTouched:)];
                            [secondImageViewGestureRecognizer setNumberOfTapsRequired:1];
                            [secondImageViewGestureRecognizer setDelegate:self];
                            
                            self.secondCollectionBG.userInteractionEnabled = YES;
                            [self.secondCollectionBG addGestureRecognizer:secondImageViewGestureRecognizer];
                        }];
                        break;
                    }
                    case 3 :{
                        [UIView animateWithDuration:0.5f animations:^{
                            thirdTitle.text = title;
                            thirdTitle.font = customFont;
                            thirdCollectionBG.image = cc.image;
                            thirdCollectionBG.alpha = COLLECTIONBGALPHA;
                            UITapGestureRecognizer *thirdImageViewGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ThirdImageTouched:)];
                            [thirdImageViewGestureRecognizer setNumberOfTapsRequired:1];
                            [thirdImageViewGestureRecognizer setDelegate:self];
                            
                            self.thirdCollectionBG.userInteractionEnabled = YES;
                            [self.thirdCollectionBG addGestureRecognizer:thirdImageViewGestureRecognizer];
                        }];
                        break;
                    }
                    case 4 :{
                        [UIView animateWithDuration:0.5f animations:^{
                            fourthTitle.text = title;
                            fourthTitle.font = customFont;
                            fourthCollectionBG.image = cc.image;
                            fourthCollectionBG.alpha = COLLECTIONBGALPHA;
                            UITapGestureRecognizer *fourthImageViewGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(FourthImageTouched:)];
                            [fourthImageViewGestureRecognizer setNumberOfTapsRequired:1];
                            [fourthImageViewGestureRecognizer setDelegate:self];
                            
                            self.fourthCollectionBG.userInteractionEnabled = YES;
                            [self.fourthCollectionBG addGestureRecognizer:fourthImageViewGestureRecognizer];
                        }];
                        break;
                    }   
                    default: {
                        if (ithCollectionBG == nil){
                            ithCollectionBG = [[UIImageView alloc] initWithFrame:CGRectMake(firstCollectionBG.frame.origin.x, COLLECTIONINBETWEEN + (i-5)*(fourthCollectionBG.frame.origin.y + fourthCollectionBG.frame.size.height + COLLECTIONINBETWEEN), fourthCollectionBG.frame.size.width, fourthCollectionBG.frame.size.height)];
    
                        }
                        else {
                            [ithCollectionBG setFrame:CGRectMake(firstCollectionBG.frame.origin.x, COLLECTIONINBETWEEN + (i-5)*(fourthCollectionBG.frame.origin.y + fourthCollectionBG.frame.size.height + COLLECTIONINBETWEEN), fourthCollectionBG.frame.size.width, fourthCollectionBG.frame.size.height)];

                        }
                        ithCollectionBG.image = cc.image;
                        ithCollectionBG.userInteractionEnabled = YES;
                        UILabel *collectionName = [[UILabel alloc] initWithFrame:CGRectMake(ithCollectionBG.frame.origin.x + 18, ithCollectionBG.frame.origin.y + 18, self.fourthTitle.frame.size.width, self.fourthTitle.frame.size.height)];
                        collectionName.text = title;
                        collectionName.font = customFont;
                        collectionName.userInteractionEnabled = NO;
                        [ithCollectionBG addSubview:collectionName];
                        [self.scrolley addSubview:ithCollectionBG];
                        ithCollectionBG.alpha = COLLECTIONBGALPHA;
                        UITapGestureRecognizer *imageViewGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ithImageTouched:)];
                        [imageViewGestureRecognizer setNumberOfTapsRequired:1];
                        [imageViewGestureRecognizer setDelegate:self];
                        
                        ithCollectionBG.userInteractionEnabled = YES;
                        ithCollectionBG.tag = i;
                        [ithCollectionBG addGestureRecognizer:imageViewGestureRecognizer];
                        break;
                    }
                }
                
                
                [colls addObject:cc];
                i++;
            }
            self.currentUser.popularCollections = colls;
            break;
        }
        case GETCERTAINCOLLECTION: {
            // TODO
            NSLog(@"CERTAIN COLLECTION WITH RESPONSE: %@", dictResponse);
            
            NSMutableArray *stories = [[NSMutableArray alloc] init];
            
            NSArray *array = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
            
            stories = [self createStoriesFromResponse:array];
            NSLog(@"STORIES????: %@", stories);
            
            if (self.currentUser.currentCollection != NULL) {
                // update singleton dictionary of stories for a collection
//                [self.currentUser.storiesForCollectionWithId setObject:stories forKey:[NSString stringWithFormat:@"%d", selectedCollection]];
                [self.currentUser setCurrentStories:stories];
                
//                NSLog(@"storing stories for %d: %@", self.currentUser.currentCollectionId, [self.currentUser.storiesForCollectionWithId objectForKey:[NSString stringWithFormat:@"%d", self.currentUser.currentCollectionId]]);
            }
            selectedCollection = -1;
            
            
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
