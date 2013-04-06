//
//  CloudableCollectionsViewController.m
//  cloudable
//
//  Created by Nathan Fraenkel on 3/29/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import "CloudableCollectionsViewController.h"

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
    
    self.currentUser = [CloudableCurrentLoggedInUser sharedDataModel];

    // update log in button, fetch collections
    [self refreshView];
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
