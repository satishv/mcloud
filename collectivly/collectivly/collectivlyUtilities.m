//
//  collectivlyUtilities.m
//  collectivly
//
//  Created by Nathan Fraenkel on 7/20/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import "collectivlyUtilities.h"

@implementation collectivlyUtilities

+(void)createAndShowDismissableAlertviewWithTitle:(NSString *)t andMessage:(NSString *)m {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: t
                          message: m
                          delegate: self
                          cancelButtonTitle:@"Dismiss"
                          otherButtonTitles:nil];
    [alert show];
}

+(BOOL)validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

@end
