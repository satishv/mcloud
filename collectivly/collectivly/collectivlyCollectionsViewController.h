//
//  collectivlyCollectionsViewController.h
//  collectivly
//
//  Created by Nathan Fraenkel on 4/6/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "collectivlySingleton.h"
#import "collectivlyCollection.h"
#import "collectivlyStory.h"

@interface collectivlyCollectionsViewController : UIViewController <NSURLConnectionDataDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate> {
    int requestNumber;
    NSMutableData *_data;
    
    UIImageView *ithCollectionBG;
    
}

@property (retain) collectivlySingleton *currentUser;

//@property (retain, nonatomic) IBOutlet UINavigationBar *navBar;
@property (retain, nonatomic) IBOutlet UIButton *logInOrOutButton;

//@property (retain, nonatomic) IBOutlet collectivlyViewController *logInViewController;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (retain, nonatomic) IBOutlet UIImageView *firstCollectionBG;
@property (retain, nonatomic) IBOutlet UIImageView *secondCollectionBG;
@property (retain, nonatomic) IBOutlet UIImageView *thirdCollectionBG;
@property (retain, nonatomic) IBOutlet UIImageView *fourthCollectionBG;

@property (retain, nonatomic) IBOutlet UILabel *firstTitle;
@property (retain, nonatomic) IBOutlet UILabel *secondTitle;
@property (retain, nonatomic) IBOutlet UILabel *thirdTitle;
@property (retain, nonatomic) IBOutlet UILabel *fourthTitle;

@property (retain, nonatomic) IBOutlet UIScrollView *scrolley;

-(IBAction)LogInOrOutButtonTouched:(id)sender;

-(void)refreshView;


@end
