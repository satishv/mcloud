//
//  collectivlyWebViewController.m
//  collectivly
//
//  Created by Nathan Fraenkel on 6/29/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import "collectivlyWebViewController.h"

@interface collectivlyWebViewController ()

@end

@implementation collectivlyWebViewController

@synthesize webView, url, contentTitle, toolbar, backButton, forwardButton, stopButton, refreshButton;

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
    
    // nav bar setup
    [self setUpNavBar];
    
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
    label.font = [UIFont fontWithName:@"ProximaNova-Bold" size:16];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor =[UIColor whiteColor];
    label.text = [[NSString stringWithFormat:@"%@", self.contentTitle] uppercaseString];
    self.navigationItem.titleView = label;
    
}

-(IBAction)leftBarButtonItemTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
