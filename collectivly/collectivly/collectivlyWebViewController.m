//
//  collectivlyWebViewController.m
//  collectivly
//
//  Created by Nathan Fraenkel on 6/29/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import "collectivlyWebViewController.h"

#define REFRESHINDEX    4

@interface collectivlyWebViewController ()

@end

@implementation collectivlyWebViewController

@synthesize webView, url, contentTitle, toolbar, backButton, forwardButton, stopButton, refreshButton, activity;

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
    self.webView.delegate = self;
    
    // nav bar setup
    [self setUpNavBar];
    
    UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadWebView)];
    NSMutableArray *mut = [self.toolbar.items mutableCopy];
//    [mut removeObjectAtIndex:REFRESHINDEX];
    [mut insertObject:refresh atIndex:REFRESHINDEX];
    self.toolbar.items = mut;

    // load URL
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.webView stopLoading];
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
    
    // customize TITLE LABEL
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:APP_FONT_BOLD size:16];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor =[UIColor whiteColor];
    label.text = [[NSString stringWithFormat:@"%@", self.contentTitle] uppercaseString];
    self.navigationItem.titleView = label;
    
}

-(IBAction)leftBarButtonItemTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark web view delegate methods
-(void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"STARTING LOAD");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
    busy = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    busy.hidesWhenStopped = YES;
    [busy startAnimating];
    UIBarButtonItem *act = [[UIBarButtonItem alloc] initWithCustomView:busy];
    NSMutableArray *mut = [self.toolbar.items mutableCopy];
    [mut removeObjectAtIndex:REFRESHINDEX];
    [mut insertObject:act atIndex:REFRESHINDEX];
    self.toolbar.items = mut;
    
    [self setBackAndForwardButtonStates];

}
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSLog(@"DID FINISH LOAD");
    
    [busy stopAnimating];

    UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadWebView)];
    NSMutableArray *mut = [self.toolbar.items mutableCopy];
    [mut removeObjectAtIndex:REFRESHINDEX];
    [mut insertObject:refresh atIndex:REFRESHINDEX];
    self.toolbar.items = mut;

    [self setBackAndForwardButtonStates];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSLog(@"DIDFAILLOADWITHERROR: %@", error);
    
    [self setBackAndForwardButtonStates];
}

-(void)setBackAndForwardButtonStates {
    if (self.webView.canGoBack)
        self.backButton.enabled = YES;
    else
        self.backButton.enabled = NO;
    
    if (self.webView.canGoForward)
        self.forwardButton.enabled = YES;
    else
        self.forwardButton.enabled = NO;
        
}

-(void)reloadWebView {
    [self.webView reload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
