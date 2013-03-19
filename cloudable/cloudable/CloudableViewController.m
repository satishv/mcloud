//
//  CloudableViewController.m
//  cloudable
//
//  Created by Nathan Fraenkel on 1/31/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import "CloudableViewController.h"

#define INVITEFIELDSCONTENTOFFSET 70
#define SIGNINFIELDSCONTENTOFFSET 180

@interface CloudableViewController ()

@end

@implementation CloudableViewController

@synthesize firstNameTextField, lastNameTextField, emailAddressTextField, requestInviteButton, scrolley, greyBGView, errorMessageLabel;
@synthesize emailAddressSignInTextField, passwordTextField;
@synthesize inviteErrorsLabel, signInErrorsLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.firstNameTextField.delegate = self;
    self.lastNameTextField.delegate = self;
    self.emailAddressTextField.delegate = self;
    self.emailAddressSignInTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    self.scrolley.scrollEnabled = NO;
    
    self.greyBGView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.greyBGView.layer.borderWidth = 1.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark field validation functions
- (BOOL)validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

#pragma mark textField functions
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.firstNameTextField || textField == self.lastNameTextField || textField == self.emailAddressTextField){
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
    else if (textField == self.emailAddressSignInTextField){
        [self.passwordTextField becomeFirstResponder];
    }
    else if (textField == self.emailAddressTextField || textField == self.passwordTextField){
        [UIView animateWithDuration:0.5 animations:^{
            self.scrolley.contentOffset = CGPointMake(0, 0);
        }];
    }
    
    return NO;
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = [touches anyObject];
//    NSLog(@"touched!");
//    if (touch.view != firstNameTextField) {
//        [firstNameTextField resignFirstResponder];
//    }
//    else if (touch.view != lastNameTextField){
//        [lastNameTextField resignFirstResponder];
//    }
//    else if (touch.view != emailAddressTextField){
//        [emailAddressTextField resignFirstResponder];
//    }
//}

#pragma mark button listeners
- (IBAction)requestButtonTouched:(id)sender {
    
    // check for empty names, last names
    if (firstNameTextField.text.length == 0 || lastNameTextField.text.length == 0){
        [UIView animateWithDuration:0.5 animations:^{
            inviteErrorsLabel.text = @"these fields are required.";
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

#pragma mark HTTP requests
-(void)requestInvite {
    NSLog(@"requesting invite...");
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSMutableDictionary *user = [[NSMutableDictionary alloc] init];
    [user setValue:self.firstNameTextField.text forKey:@"first_name"];
    [user setValue:self.lastNameTextField.text forKey:@"last_name"];
    [user setValue:self.emailAddressTextField.text forKey:@"email"];
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    [dataDict setValue:@"iJNKwC1U5uVrOIA8mEB6Pxyk4FU/EmW8rmjY28doDuc=" forKey:@"authenticity_token"];
    [dataDict setValue:user forKey:@"user"];
    
    NSString *url = @"http://cloudable.me/users/invitation";
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
    [dataDict setValue:@"iJNKwC1U5uVrOIA8mEB6Pxyk4FU/EmW8rmjY28doDuc=" forKey:@"authenticity_token"];
    [dataDict setValue:user forKey:@"user"];
    
    NSString *url = @"http://cloudable.me/users/sign_in";
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
    
    NSLog(@"response data: %@", [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding]);
    
    NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
    NSLog(@"dictionary form: %@", dictResponse);
    NSLog(@"status: %@", [dictResponse objectForKey:@"status"]);

    
    
}

#pragma mark cleanup
- (void)viewDidUnload {
    [self setFirstNameTextField:nil];
    [self setLastNameTextField:nil];
    [self setEmailAddressTextField:nil];
    [self setEmailAddressSignInTextField:nil];
    [self setPasswordTextField:nil];
    [self setInviteErrorsLabel:nil];
    [self setSignInErrorsLabel:nil];
    [super viewDidUnload];
}

@end