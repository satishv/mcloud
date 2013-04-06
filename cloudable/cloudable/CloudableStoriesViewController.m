//
//  CloudableStoriesViewController.m
//  cloudable
//
//  Created by Nathan Fraenkel on 3/22/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import "CloudableStoriesViewController.h"

@interface CloudableStoriesViewController ()

@end

@implementation CloudableStoriesViewController

@synthesize currentUser;

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
    NSLog(@"[CloudableStoriesViewController] viewdidload");
    
    self.currentUser = [CloudableCurrentLoggedInUser sharedDataModel];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
