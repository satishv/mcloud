//
//  collectivlySidebarViewController.h
//  collectivly
//
//  Created by Nathan Fraenkel on 5/27/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol collectivlySidebarViewControllerDelegate;


@interface collectivlySidebarViewController : UIViewController <UITableViewDelegate, UITableViewDelegate> {
    NSIndexPath *selectedCollectionsIndex;
    NSIndexPath *selectedCollectorIndex;
}

@property (nonatomic, assign) id <collectivlySidebarViewControllerDelegate> sidebarDelegate;
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;

@end

@protocol collectivlySidebarViewControllerDelegate <NSObject>

- (void)sidebarViewController:(collectivlySidebarViewController *)sidebarViewController didSelectObject:(NSObject *)object atIndexPath:(NSIndexPath *)indexPath;

@optional
- (NSIndexPath *)lastSelectedIndexPathForSidebarViewController:(collectivlySidebarViewController *)sidebarViewController;

@end

