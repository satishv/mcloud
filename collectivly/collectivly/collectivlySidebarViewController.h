//
//  collectivlySidebarViewController.h
//  collectivly
//
//  Created by Nathan Fraenkel on 5/27/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "collectivlySingleton.h"

@class collectivlySidebarViewController;

@protocol collectivlySidebarViewControllerDelegate <NSObject>
- (void)sidebarViewController:(collectivlySidebarViewController *)sidebarViewController didSelectObject:(NSObject *)object atIndexPath:(NSIndexPath *)indexPath;
- (void)didSelectLoginSignUpButton;
@optional
- (NSIndexPath *)lastSelectedIndexPathForSidebarViewController:(collectivlySidebarViewController *)sidebarViewController;
@end


@interface collectivlySidebarViewController : UIViewController <UITableViewDelegate, UITableViewDelegate> {
    NSIndexPath *selectedCollectionsIndex, *selectedCollectorIndex;
}

@property (nonatomic, assign) id <collectivlySidebarViewControllerDelegate> sidebarDelegate;
@property (nonatomic, weak) IBOutlet UITableView *table;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *profileImageView;
@property (nonatomic, strong) collectivlySingleton *currentUser;
@property (weak, nonatomic) IBOutlet UIButton *loginSignUpButton;

-(void)updateUserNameDisplay;
- (IBAction)loginSignUpTouched:(id)sender;

@end


