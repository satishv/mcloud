//
//  CloudableViewController.m
//  cloudable
//
//  Created by Nathan Fraenkel on 1/31/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import "CloudableViewController.h"

#define SCROLLCONTENTOFFSET

@interface CloudableViewController ()

@end

@implementation CloudableViewController

@synthesize cloudCountLabel, firstNameTextField, lastNameTextField, emailAddressTextField, requestInviteButton, scrolley, greyBGView, errorMessageLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // clear label text to start
    self.cloudCountLabel.text = @"";
    
    self.firstNameTextField.delegate = self;
    self.lastNameTextField.delegate = self;
    self.emailAddressTextField.delegate = self;
    
    self.scrolley.scrollEnabled = NO;
    
    self.greyBGView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.greyBGView.layer.borderWidth = 1.0;
    
    // get the cloud count
    [self fetchCloudCount];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// HTTP GET request to fetch number of cloud in system
- (void)fetchCloudCount {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *url = [NSString stringWithFormat:@"http://cloudable.me/stories/count.json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"GET"];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    
    
}

- (BOOL)validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.5 animations:^{
        self.scrolley.contentOffset = CGPointMake(0, 116);
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    if (textField == self.firstNameTextField){
        [self.lastNameTextField becomeFirstResponder];
    }
    else if (textField == self.lastNameTextField){
        [self.emailAddressTextField becomeFirstResponder];
    }
    else if (textField == emailAddressTextField){
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

- (IBAction)requestButtonTouched:(id)sender {
    
    NSLog(@"%@", ([self validateEmail:emailAddressTextField.text]) ? @"YES" : @"NO");
    [self requestInvite];
}


-(void) requestInvite {
    NSLog(@"request!!!!");
    
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
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0){
        // CANCEL
        
    }
    else if (buttonIndex == 1){
        // RETRY
        [self fetchCloudCount];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectiondidfinishloading!");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSLog(@"response data: %@", [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding]);
    
    
    self.cloudCountLabel.text = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
    
    
}


@end