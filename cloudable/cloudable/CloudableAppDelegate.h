//
//  CloudableAppDelegate.h
//  cloudable
//
//  Created by Nathan Fraenkel on 3/14/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class CloudableViewController;
@class CloudableCollectionsViewController;

@interface CloudableAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CloudableCollectionsViewController *viewController;

@end
