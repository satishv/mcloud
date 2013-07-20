//
//  collectivlyUtilities.h
//  collectivly
//
//  Created by Nathan Fraenkel on 7/20/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface collectivlyUtilities : NSObject

+(void)createAndShowDismissableAlertviewWithTitle:(NSString*)t andMessage:(NSString*)m;
+(BOOL)validateEmail: (NSString *) candidate;
@end
