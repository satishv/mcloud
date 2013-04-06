//
//  CloudableCollectionsViewController.m
//  cloudable
//
//  Created by Nathan Fraenkel on 3/29/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import "CloudableCollectionsViewController.h"

#define REQUESTHOMEPAGE     1

@interface CloudableCollectionsViewController ()

@end

@implementation CloudableCollectionsViewController

@synthesize currentUser, navBar, logInOrOutButton;

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
    NSLog(@"[CloudableCollectionsViewController] viewdidload");
    
    // request number 0 initially
    requestNumber = 0;
    
    self.currentUser = [CloudableCurrentLoggedInUser sharedDataModel];
    self.currentUser.authToken = @"";

    // update log in button, fetch collections
    [self refreshView];
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
    
    [self fetchCollections];
}

-(void)fetchCollections {
    if ([self someoneIsLoggedIn]){
        NSLog(@"[CloudableCollectionsViewController] display collections specific current logged in user!");
        
    }
    else {
        NSLog(@"[CloudableCollectionsViewController] display most popular collections, because no one is logged in!");

        
    }
    
}

- (IBAction)LogInOrOutButtonTouched:(id)sender {
    if (self.currentUser.isLoggedIn){
        // TODO: LOG USER OUT
    }
    else {
        
        CloudableViewController *logInViewController = [[CloudableViewController alloc] initWithNibName:@"CloudableViewController" bundle:nil];
        logInViewController.parent = self;
        [self presentViewController:logInViewController animated:YES completion:^{
            
            
        }];
    }
    
}

#pragma mark HTTP requests
-(void)requestHomePage {
    NSLog(@"HOME PAGE!!!");
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
    
    
    // act based on what the request was (requestinvite, requestsignin, etc)
    switch (requestNumber)
    {
        case REQUESTHOMEPAGE:
            // SET auth token
            self.currentUser.authToken = [self extractAuthToken:responseString];
            break;
        default:
            break;
    }
    
}

#pragma mark memory stuffs
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setNavBar:nil];
    [self setLogInOrOutButton:nil];
    [self setLogInOrOutButton:nil];
    [super viewDidUnload];
}

@end
