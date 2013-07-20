//
//  collectivlyViewController.h
//  collectivly
//
//  Created by Nathan Fraenkel on 4/6/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "collectivlyCollectionsViewController.h"
#import "collectivlySingleton.h"
#import "collectivlyStory.h"
#import "collectivlyAppDelegate.h"
#import "collectivlyUtilities.h"

#import "SignUserInCommand.h"
#import "RequestInviteCommand.h"


@interface collectivlyViewController : UIViewController <NSURLConnectionDataDelegate, UIAlertViewDelegate, UITextFieldDelegate, UIScrollViewDelegate, SignUserInDelegate, RequestInviteDelegate> {
    NSMutableData *_data;
    
    collectivlyCollectionsViewController *parent;
}
@property (retain) collectivlySingleton *currentUser;

@property (retain, nonatomic) collectivlyCollectionsViewController *parent;

@property (retain, nonatomic) IBOutlet UIScrollView *scrolley;
@property (retain, nonatomic) IBOutlet UIView *greyBGView;
@property (retain, nonatomic) IBOutlet UILabel *errorMessageLabel;
@property (retain, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (retain, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (retain, nonatomic) IBOutlet UITextField *emailAddressTextField;
@property (retain, nonatomic) IBOutlet UITextField *invitePasswordTextField;
@property (retain, nonatomic) IBOutlet UITextField *inviteConfirmPasswordTextField;
@property (retain, nonatomic) IBOutlet UIButton *requestInviteButton;
- (IBAction)requestButtonTouched:(id)sender;

@property (retain, nonatomic) IBOutlet UITextField *emailAddressSignInTextField;
@property (retain, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)signInButtonTouched:(id)sender;

@property (retain, nonatomic) IBOutlet UILabel *inviteErrorsLabel;
@property (retain, nonatomic) IBOutlet UILabel *signInErrorsLabel;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *closeButtonTouched;



@end
