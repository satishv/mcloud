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

//#define REQUESTHOMEPAGE             1
#define REQUESTINVITE               2
#define REQUESTSIGNIN               3

@interface collectivlyViewController ()

@end

@implementation collectivlyViewController

@synthesize firstNameTextField, lastNameTextField, emailAddressTextField, invitePasswordTextField, inviteConfirmPasswordTextField, requestInviteButton, scrolley, greyBGView, errorMessageLabel;
@synthesize emailAddressSignInTextField, passwordTextField;
@synthesize inviteErrorsLabel, signInErrorsLabel, parent;
@synthesize currentUser;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.currentUser = [collectivlySingleton sharedDataModel];
    
    self.firstNameTextField.delegate = self;
    self.lastNameTextField.delegate = self;
    self.emailAddressTextField.delegate = self;
    self.emailAddressSignInTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.invitePasswordTextField.delegate = self;
    self.inviteConfirmPasswordTextField.delegate = self;
    
    self.scrolley.scrollEnabled = NO;
    
    self.greyBGView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.greyBGView.layer.borderWidth = 1.0;
    
    // gets updated every time a request is made
    // checked in connectionDidFinishLoading
    requestNumber = 0;
}

#pragma mark helper functions
- (BOOL)validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

-(BOOL)checkValidityOfSignIn:(NSString *)string {
    NSRange range = [string rangeOfString:@"Invalid email or password."];
    // if NOT FOUND --> good email  --> email is VALID  --> return TRUE
    // if found     --> bad email   --> email not VALID --> return false
    return (range.location == NSNotFound);
}

-(NSMutableArray *)createStoriesFromResponse:(NSArray*)array {
    NSMutableArray *stories = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; i++){
        NSLog(@"STORYYY %d: %@", i, [array objectAtIndex:i]);
        collectivlyStory *story = [[collectivlyStory alloc] initWithDictionary:[array objectAtIndex:i]];
        [stories addObject:story];
        
    }
    return stories;
}

#pragma mark textField functions
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



#pragma mark button listeners
- (IBAction)requestButtonTouched:(id)sender {
    
    // check for empty names, last names
    if (firstNameTextField.text.length == 0 || lastNameTextField.text.length == 0 || self.emailAddressTextField.text.length == 0 || self.invitePasswordTextField.text.length == 0 || self.inviteConfirmPasswordTextField.text.length == 0){
        [UIView animateWithDuration:0.5 animations:^{
            inviteErrorsLabel.text = @"these fields are required.";
            inviteErrorsLabel.alpha = 1.0f;
        }];
    }
    // check that passwords match
    else if (![self.invitePasswordTextField.text isEqualToString:self.inviteConfirmPasswordTextField.text]){
        [UIView animateWithDuration:0.5 animations:^{
            inviteErrorsLabel.text = @"please enter matching passwords.";
            inviteErrorsLabel.alpha = 1.0f;
        }];
    }
    // check for valid email
    else if (![self validateEmail:emailAddressTextField.text]){
        [UIView animateWithDuration:0.5 animations:^{
            inviteErrorsLabel.text = @"please enter a valid e-mail address.";
            inviteErrorsLabel.alpha = 1.0f;
        }];
    }
    else {
        [self requestInvite];
    }
}

- (IBAction)signInButtonTouched:(id)sender {
    NSLog(@"SIGN IN!!!!");
    // check for empty email, password
    if (emailAddressSignInTextField.text.length == 0 || passwordTextField.text.length == 0){
        [UIView animateWithDuration:0.5 animations:^{
            signInErrorsLabel.text = @"these fields are required.";
            signInErrorsLabel.alpha = 1.0f;
        }];
    }
    // check for valid email
    else if (![self validateEmail:emailAddressSignInTextField.text]){
        [UIView animateWithDuration:0.5 animations:^{
            signInErrorsLabel.text = @"please enter a valid e-mail address.";
            signInErrorsLabel.alpha = 1.0f;
        }];
    }
    else {
        [self signUserIn];
    }
}

-(IBAction)closeButtonTouched:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
        
    }];
}


#pragma mark HTTP requests
-(void)requestInvite {
    NSLog(@"requesting invite...");
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSMutableDictionary *user = [[NSMutableDictionary alloc] init];
    [user setValue:self.firstNameTextField.text forKey:@"first_name"];
    [user setValue:self.lastNameTextField.text forKey:@"last_name"];
    [user setValue:self.emailAddressTextField.text forKey:@"email"];
    [user setValue:self.invitePasswordTextField.text forKey:@"password"];
    [user setValue:self.inviteConfirmPasswordTextField.text forKey:@"password_confirmation"];
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    [dataDict setValue:self.currentUser.authToken forKey:@"authenticity_token"];
    [dataDict setValue:user forKey:@"user"];
    
    NSString *url = @"https://cloudable.me/users/invitation";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSString *data = [NSString stringWithFormat:@""];
    NSData *postData = ([NSJSONSerialization isValidJSONObject:dataDict]) ? [NSJSONSerialization dataWithJSONObject:dataDict options:NSJSONWritingPrettyPrinted error:nil] : [data dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@", postData);
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    // HTTP request, setting stuff
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    // SET REQUEST NUMBER TO APPROPRIATE VALUE
    requestNumber = REQUESTINVITE;
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

-(void)signUserIn {
    NSLog(@"signing in...");
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSMutableDictionary *user = [[NSMutableDictionary alloc] init];
    [user setValue:self.emailAddressSignInTextField.text forKey:@"email"];
    [user setValue:self.passwordTextField.text forKey:@"password"];
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    [dataDict setValue:self.currentUser.authToken forKey:@"authenticity_token"];
    [dataDict setValue:user forKey:@"user"];
    
    NSString *url = @"https://cloudable.me/users/sign_in";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSString *data = [NSString stringWithFormat:@""];
    NSData *postData = ([NSJSONSerialization isValidJSONObject:dataDict]) ? [NSJSONSerialization dataWithJSONObject:dataDict options:NSJSONWritingPrettyPrinted error:nil] : [data dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@", postData);
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    // HTTP request, setting stuff
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    // SET REQUEST NUMBER TO APPROPRIATE VALUE
    requestNumber = REQUESTSIGNIN;
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    
}

#pragma mark connection protocol functions
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"conection did receive response!");
    _data = [[NSMutableData alloc] init];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"conection did receive data!");
    [_data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // Please do something sensible here, like log the error.
    NSLog(@"connection failed with error: %@", error.description);
    
    // stop spinner
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // alert view for network error
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Network Error"
                          message: @"There was a network error :\\"
                          delegate: self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"Retry", nil];
    [alert show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectiondidfinishloading!");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSString *responseString = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
    NSLog(@"response data: %@", responseString);
    
    NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
    
    
    // act based on what the request was (requestinvite, requestsignin, etc)
    switch (requestNumber)
    {
            //        case REQUESTHOMEPAGE:
            //            // SET auth token
            //            auth_token = [self extractAuthToken:responseString];
            //            break;
        case REQUESTINVITE:
            if ([[dictResponse objectForKey:@"status"] isEqualToString:@"success"]){
                // pop up success alert view
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle: @"Success!"
                                      message: [dictResponse objectForKey:@"msg"]
                                      delegate: self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
                [alert show];
            }
            break;
        case REQUESTSIGNIN:
            // if BAD SIGN IN
            if (![self checkValidityOfSignIn:(NSString *)responseString]){
                // THEN, disply red text
                [UIView animateWithDuration:0.5 animations:^{
                    signInErrorsLabel.text = @"Invalid email or password.";
                    signInErrorsLabel.alpha = 1.0f;
                }];
            }
            else {
                // O.W, display content!!! YEEE!!!
                NSMutableArray *stories = [[NSMutableArray alloc] init];
                
                NSArray *array = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
                
                stories = [self createStoriesFromResponse:array];
                
                // POPULATE SINGLETON STORIES FOR LOGGED IN USER
                currentUser.isLoggedIn = TRUE;
                currentUser.stories = stories;
                
                [self dismissViewControllerAnimated:YES completion:^{
                    [self.parent refreshView];
                }];
                
            }
            break;
        default:
            break;
    }
    
}


#pragma mark memory stuffs
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end