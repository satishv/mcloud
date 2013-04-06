//
//  CloudableCollectionsViewController.h
//  cloudable
//
//  Created by Nathan Fraenkel on 3/29/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CloudableCurrentLoggedInUser.h"
#import "CloudableViewController.h"

@interface CloudableCollectionsViewController : UIViewController

@property (retain) CloudableCurrentLoggedInUser *currentUser;

@property (retain, nonatomic) IBOutlet UINavigationBar *navBar;
@property (retain, nonatomic) IBOutlet UIButton *logInOrOutButton;

//@property (retain, nonatomic) CloudableViewController *logInViewController;

- (IBAction)LogInOrOutButtonTouched:(id)sender;

-(void)refreshView;

@end
