//
//  LeftSidebarViewController.m
//  JTRevealSidebarDemo
//
//  Created by James Apple Tang on 12/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SidebarViewController.h"


@implementation SidebarViewController
@synthesize sidebarDelegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"[SidebarViewController] viewdidload");
    
    selectedFilterIndex = nil;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if ([self.sidebarDelegate respondsToSelector:@selector(lastSelectedIndexPathForSidebarViewController:)]) {
        NSIndexPath *indexPath = [self.sidebarDelegate lastSelectedIndexPathForSidebarViewController:self];
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 3;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0){
        static NSString *CellIdentifier = @"rightSideLogin";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.textLabel.text = @"Login";
    }
    else {
        static NSString *CellIdentifier = @"rightSideFilter";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        if (selectedFilterIndex.row == indexPath.row){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"All";
                if (selectedFilterIndex == nil){
                    selectedFilterIndex = indexPath;
                }
                break;
            case 1:
                cell.textLabel.text = @"Recommended";
                break;
            case 2:
                cell.textLabel.text = @"Yours";
                break;
            default:
                break;
        }
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Manage Your Session";
        case 1:
            return @"Filter Collections";
        default:
            break;
    }
    return self.title;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.sidebarDelegate) {
        if (indexPath.section == 1){
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:selectedFilterIndex];
            cell.accessoryType = UITableViewCellAccessoryNone;
            selectedFilterIndex = indexPath;
            UITableViewCell *cell2 = [self.tableView cellForRowAtIndexPath:indexPath];
            cell2.accessoryType = UITableViewCellAccessoryCheckmark;

        }
        NSObject *object = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        [self.sidebarDelegate sidebarViewController:self didSelectObject:object atIndexPath:indexPath];
    }
}

@end
