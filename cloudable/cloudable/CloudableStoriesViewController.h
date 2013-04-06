//
//  CloudableStoriesViewController.h
//  cloudable
//
//  Created by Nathan Fraenkel on 3/22/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CloudableCurrentLoggedInUser.h"

@interface CloudableStoriesViewController : UIViewController

@property (retain) CloudableCurrentLoggedInUser *currentUser;

@end
