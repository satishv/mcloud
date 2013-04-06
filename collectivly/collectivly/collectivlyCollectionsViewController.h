//
//  collectivlyCollectionsViewController.h
//  collectivly
//
//  Created by Nathan Fraenkel on 4/6/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "collectivlySingleton.h"
//#import "collectivlyViewController.h"

@interface collectivlyCollectionsViewController : UIViewController <NSURLConnectionDataDelegate> {
    int requestNumber;
    NSMutableData *_data;
    
}

@property (retain) collectivlySingleton *currentUser;

//@property (retain, nonatomic) IBOutlet UINavigationBar *navBar;
@property (retain, nonatomic) IBOutlet UIButton *logInOrOutButton;

//@property (retain, nonatomic) IBOutlet collectivlyViewController *logInViewController;

-(IBAction)LogInOrOutButtonTouched:(id)sender;

-(void)refreshView;


@end
