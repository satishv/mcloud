//
//  collectivlySidebarViewController.m
//  collectivly
//
//  Created by Nathan Fraenkel on 5/27/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import "collectivlySidebarViewController.h"

@interface collectivlySidebarViewController ()

@end

@implementation collectivlySidebarViewController

@synthesize table, sidebarDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self.sidebarDelegate respondsToSelector:@selector(lastSelectedIndexPathForSidebarViewController:)]) {
        NSIndexPath *indexPath = [self.sidebarDelegate lastSelectedIndexPathForSidebarViewController:self];
        [self.table selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSLog(@"[collectivlySidebarViewController] viewdidload");
    
    selectedCollectionsIndex = nil;
    selectedCollectorIndex = nil;
}

#pragma mark TableViewDataSourceDelegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 4;
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
    
    UIImageView *checkMark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check_selected.png"]];
    
    if (indexPath.section == 0){
        static NSString *CellIdentifier = @"rightSideCollections";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        
        if (selectedCollectionsIndex.row == indexPath.row){
            cell.accessoryView = checkMark;
            
        }
        else {
            cell.accessoryView = nil;
        }
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"All";
                if (selectedCollectionsIndex == nil){
                    selectedCollectionsIndex = indexPath;
                }
                break;
            case 1:
                cell.textLabel.text = @"Yours";
                break;
            case 2:
                cell.textLabel.text = @"Nearby";
                break;
            case 3:
                cell.textLabel.text = @"Trending";
                break;
            default:
                break;
        }
        
    }
    else if (indexPath.section == 1) {
        static NSString *CellIdentifier = @"rightSideCollectors";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        if (selectedCollectorIndex.row == indexPath.row){
            cell.accessoryView = checkMark;
            
        }
        else {
            cell.accessoryView = nil;
        }
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Everyone";
                if (selectedCollectorIndex == nil){
                    selectedCollectorIndex = indexPath;
                }
                break;
            case 1:
                cell.textLabel.text = @"Friends";
                break;
            case 2:
                cell.textLabel.text = @"You";
                break;
            default:
                break;
        }
    }
    
    CGRect t = cell.textLabel.frame;
    cell.textLabel.frame = CGRectMake(t.origin.x + 100, t.origin.y, t.size.width, t.size.height);
    
    checkMark.frame = CGRectMake(t.origin.x, checkMark.frame.origin.y, checkMark.frame.size.width, checkMark.frame.size.height);
    
    cell.textLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:22];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Collections";
        case 1:
            return @"Collectors";
        default:
            break;
    }
    return self.title;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *headerLabel = [[UILabel alloc] init];
    switch (section) {
        case 0:
            headerLabel.text = @"Collections";
            break;
        case 1:
            headerLabel.text = @"Collectors";
            break;
        default:
            break;
    }
    headerLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:22];
    headerLabel.backgroundColor = [UIColor clearColor];
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"submenu_lightgrey.png"]];
    bg.frame = CGRectMake(0, 0, 320, 60);
    [bg addSubview:headerLabel];
    headerLabel.frame = CGRectMake(0, 0, 300, 45);
    return bg;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section:(NSInteger)section {
    
}

#pragma mark TableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.sidebarDelegate) {
        if (indexPath.section == 0){
            UITableViewCell *cell = [self.table cellForRowAtIndexPath:selectedCollectionsIndex];
            ((UIImageView *)(cell.accessoryView)).image = [UIImage imageNamed:@"nothing!!!!!!"];
            selectedCollectionsIndex = indexPath;
            UITableViewCell *cell2 = [self.table cellForRowAtIndexPath:indexPath];
            cell2.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check_selected.png"]];
            
            
        }
        else if (indexPath.section == 1) {
            UITableViewCell *cell = [self.table cellForRowAtIndexPath:selectedCollectorIndex];
            ((UIImageView *)(cell.accessoryView)).image = [UIImage imageNamed:@"nothing!!!!!!"];
            selectedCollectorIndex = indexPath;
            UITableViewCell *cell2 = [self.table cellForRowAtIndexPath:indexPath];
            cell2.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check_selected.png"]];
            
            
        }
        NSObject *object = [self.table cellForRowAtIndexPath:indexPath].textLabel.text;
        [self.sidebarDelegate sidebarViewController:self didSelectObject:object atIndexPath:indexPath];
    }
}

#pragma mark memory stuffz

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
