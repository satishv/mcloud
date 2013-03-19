//
//  CloudableViewController.h
//  cloudable
//
//  Created by Nathan Fraenkel on 3/14/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CloudableViewController : UIViewController <NSURLConnectionDataDelegate, UIAlertViewDelegate, UITextFieldDelegate, UIScrollViewDelegate> {
    NSMutableData *_data;
}
@property (retain, nonatomic) IBOutlet UIScrollView *scrolley;
@property (retain, nonatomic) IBOutlet UIView *greyBGView;
@property (retain, nonatomic) IBOutlet UILabel *errorMessageLabel;
@property (retain, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (retain, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (retain, nonatomic) IBOutlet UITextField *emailAddressTextField;
@property (retain, nonatomic) IBOutlet UIButton *requestInviteButton;
- (IBAction)requestButtonTouched:(id)sender;

@property (retain, nonatomic) IBOutlet UITextField *emailAddressSignInTextField;
@property (retain, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)signInButtonTouched:(id)sender;

@property (retain, nonatomic) IBOutlet UILabel *inviteErrorsLabel;
@property (retain, nonatomic) IBOutlet UILabel *signInErrorsLabel;

@end