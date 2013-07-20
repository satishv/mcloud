//
//  collectivlyViewController.m
//  collectivly
//
//  Created by Nathan Fraenkel on 4/6/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import "collectivlyViewController.h"

#define SIGNINFIELDSCONTENTOFFSET   5
#define INVITEFIELDSCONTENTOFFSET   200

@interface collectivlyViewController ()

@end

@implementation collectivlyViewController

@synthesize firstNameTextField, lastNameTextField, emailAddressTextField, invitePasswordTextField, inviteConfirmPasswordTextField, requestInviteButton, scrolley, greyBGView, errorMessageLabel;
@synthesize emailAddressSignInTextField, passwordTextField;
@synthesize inviteErrorsLabel, signInErrorsLabel, parent, closeButtonTouched;
@synthesize currentUser;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.currentUser = [collectivlySingleton sharedDataModel];
    
    self.scrolley.scrollEnabled = NO;
    
    self.greyBGView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.greyBGView.layer.borderWidth = 1.0;

}

#pragma mark - textField functions
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.firstNameTextField || textField == self.lastNameTextField || textField == self.emailAddressTextField || textField == self.invitePasswordTextField || textField == self.inviteConfirmPasswordTextField){
        [UIView animateWithDuration:0.5 animations:^{
            self.scrolley.contentOffset = CGPointMake(0, INVITEFIELDSCONTENTOFFSET);
        }];
        
    }
    if (textField == self.emailAddressSignInTextField || textField == self.passwordTextField){
        [UIView animateWithDuration:0.5 animations:^{
            self.scrolley.contentOffset = CGPointMake(0, SIGNINFIELDSCONTENTOFFSET);
        }];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    if (textField == self.firstNameTextField){
        [self.lastNameTextField becomeFirstResponder];
    }
    else if (textField == self.lastNameTextField){
        [self.emailAddressTextField becomeFirstResponder];
    }
    else if (textField == self.emailAddressTextField){
        [self.invitePasswordTextField becomeFirstResponder];
    }
    else if (textField == self.invitePasswordTextField){
        [self.inviteConfirmPasswordTextField becomeFirstResponder];
    }
    else if (textField == self.emailAddressSignInTextField){
        [self.passwordTextField becomeFirstResponder];
    }
    else if (textField == self.inviteConfirmPasswordTextField || textField == self.passwordTextField){
        [UIView animateWithDuration:0.5 animations:^{
            self.scrolley.contentOffset = CGPointMake(0, 0);
        }];
    }
    
    return NO;
}



#pragma mark - button listeners
- (IBAction)requestButtonTouched:(id)sender {
    
    BOOL someFieldIsEmpty = firstNameTextField.text.length == 0 || lastNameTextField.text.length == 0 || self.emailAddressTextField.text.length == 0 || self.invitePasswordTextField.text.length == 0 || self.inviteConfirmPasswordTextField.text.length == 0;
    BOOL passwordsMatch = [self.invitePasswordTextField.text isEqualToString:self.inviteConfirmPasswordTextField.text];
    BOOL emailIsAValidEmail = [collectivlyUtilities validateEmail:emailAddressTextField.text];
    
    
    // check for empty names, last names
    if (someFieldIsEmpty){
        [collectivlyUtilities createAndShowDismissableAlertviewWithTitle:@"Empty Fields"
                                                              andMessage:@"Please complete the missing form fields for requesting an invite."];
    }
    // check that passwords match
    else if (!passwordsMatch){
        [collectivlyUtilities createAndShowDismissableAlertviewWithTitle:@"Passwords Don't Match"
                                                              andMessage:@"Please enter matching passwords."];

    }
    // check for valid email
    else if (!emailIsAValidEmail){
        [collectivlyUtilities createAndShowDismissableAlertviewWithTitle:@"Bad Email"
                                                              andMessage:@"Please enter a valid email address."];

    }
    else {
        [self requestInvite];
    }
}

- (IBAction)signInButtonTouched:(id)sender {
    NSLog(@"SIGN IN!!!!");
    // check for empty email, password
    BOOL someFieldsAreEmpty = emailAddressSignInTextField.text.length == 0 || passwordTextField.text.length == 0;
    BOOL emailFollowsFormatOfAnEmail = [collectivlyUtilities validateEmail:emailAddressSignInTextField.text];
    
    UIAlertView *al;
    
    if (someFieldsAreEmpty){
        [collectivlyUtilities createAndShowDismissableAlertviewWithTitle:@"Empty Fields"
                                                              andMessage:@"Please complete the missing form fields for sign in."];
        [self.view endEditing:YES];
    }
    else if (!emailFollowsFormatOfAnEmail){
        [collectivlyUtilities createAndShowDismissableAlertviewWithTitle:@"Bad Email"
                                                              andMessage:@"Please enter a valid email address."];
        [self.view endEditing:YES];
    }
    else {
        [self signUserIn];
    }
}

-(IBAction)closeButtonTouched:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}


#pragma mark - COMMAND execution
-(void)signUserIn {
    NSLog(@"signing in...");
    
    SignUserInCommand *cmd = [[SignUserInCommand alloc] initWithEmail:emailAddressSignInTextField.text andPass:passwordTextField.text];
    cmd.delegate = self;
    [cmd signUserIn];
    
}

-(void)requestInvite {
    NSLog(@"requesting invite...");
    
    NSString *f = self.firstNameTextField.text;
    NSString *l = self.lastNameTextField.text;
    NSString *e = self.emailAddressTextField.text;
    NSString *p = self.invitePasswordTextField.text;
    
    RequestInviteCommand *cmd = [[RequestInviteCommand alloc] initWithFirst:f andLast:l andEmail:e andPass:p];
    cmd.delegate = self;
    [cmd requestInvite];
    
}

#pragma mark - COMMAND DELEGATES
#pragma mark sign user in
-(void)successfulSignInWithAuth:(NSString *)token andEmail:(NSString *)e {
    
    self.currentUser.authToken = token;
    self.currentUser.email = e;
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self.parent refreshView];
    }];
}

-(void)errorOccuredDuringSignIn:(NSError *)error {
    [collectivlyUtilities createAndShowDismissableAlertviewWithTitle:@"Sign In Error"
                                                          andMessage:error.localizedDescription];
    [self.view endEditing:YES];
}
-(void)unsuccessfulSignInWithMessage:(NSString *)msg {
    [collectivlyUtilities createAndShowDismissableAlertviewWithTitle:@"Sign In Unsuccessful"
                                                          andMessage:msg];

    [self.view endEditing:YES];
}
#pragma mark request invite
-(void)successfulInviteWithMessage:(NSString *)message {
    [collectivlyUtilities createAndShowDismissableAlertviewWithTitle:@"Requesting Invite Successful"
                                                          andMessage:message];

    
    [self dismissViewControllerAnimated:YES completion:^{
        [self.parent refreshView];
    }];
}
-(void)errorOccuredDuringInvite:(NSError *)error {
    [collectivlyUtilities createAndShowDismissableAlertviewWithTitle:@"Error While Requesting Invite"
                                                          andMessage:error.localizedDescription];

}
-(void)unsuccessfulInvite {
    [collectivlyUtilities createAndShowDismissableAlertviewWithTitle:@"Requesting Invite Unsuccessful"
                                                          andMessage:@"There was an error while requesting an invite for your account. Please try again."];
}


#pragma mark memory stuffs
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
