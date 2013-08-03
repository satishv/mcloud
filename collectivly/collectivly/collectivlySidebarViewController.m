//
//  collectivlySidebarViewController.m
//  collectivly
//
//  Created by Nathan Fraenkel on 5/27/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import "collectivlySidebarViewController.h"

#define HEADERHEIGHT    40
#define FOOTERHEIGHT    57
#define CHECKMARKWIDTH  32
#define CHECKMARKHEIGHT 24

@interface collectivlySidebarViewController ()

@end

@implementation collectivlySidebarViewController

@synthesize table, sidebarDelegate, nameLabel, currentUser, profileImageView, loginSignUpButton;

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
    
    [self updateUserNameDisplay];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSLog(@"[collectivlySidebarViewController] viewdidload");
    
    selectedCollectionsIndex = nil;
    selectedCollectorIndex = nil;
    
    self.nameLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:20];
    
    self.currentUser = [collectivlySingleton sharedDataModel];
    
//    [self makeProfileImageViewAHexagon];
    
}

-(void)makeProfileImageViewAHexagon {
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    // TODO - make this a hexagon
    int width = self.profileImageView.frame.size.width;
    int height = self.profileImageView.frame.size.height;
    int x1 = width / 4;
    int x2 = 3 * width / 4;
    int y1 = height / 4;
    int y2 = 3 * height / 4;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 0, 0);
//    CGPathAddLineToPoint(path, NULL, newloc.x + 16,newloc.y + 38);

    CGPathRef pathRef = nil;
    
    shapeLayer.path = pathRef;
    
    self.profileImageView.layer.mask = shapeLayer;
    
    
}

- (void) updateUserNameDisplay {
    BOOL userIsLoggedIn = self.currentUser.isLoggedIn;
    
    self.nameLabel.hidden = !userIsLoggedIn;
    self.profileImageView.hidden = !userIsLoggedIn;
    self.loginSignUpButton.hidden = userIsLoggedIn;
    
    self.nameLabel.text = (userIsLoggedIn) ? [NSString stringWithFormat:@"%@ %@", self.currentUser.firstName, self.currentUser.lastName] : @"No on logged in yet.";
    self.profileImageView.image = (userIsLoggedIn) ? self.currentUser.profileImage : nil;
    
}

- (IBAction)loginSignUpTouched:(id)sender {
    [self.sidebarDelegate didSelectLoginSignUpButton];
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
    
    cell.textLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:20];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    cell.accessoryView.frame = CGRectMake(0, 0, CHECKMARKWIDTH, CHECKMARKHEIGHT);
    
    return cell;
}

#pragma mark header methods
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return HEADERHEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *headerLabel = [[UILabel alloc] init];
    switch (section) {
        case 0:
            headerLabel.text = @"Collections";
            break;
        case 1:
            headerLabel.text = @"Collector";
            break;
        default:
            break;
    }
    headerLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:20];
    headerLabel.backgroundColor = [UIColor clearColor];
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"submenu_lightgrey.png"]];
    bg.frame = CGRectMake(0, 0, 320, HEADERHEIGHT);
    [bg addSubview:headerLabel];
    headerLabel.frame = CGRectMake(10, HEADERHEIGHT / 8, 270, HEADERHEIGHT * 3 / 4);
    return bg;
}


#pragma mark footer methods
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIImageView *footer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_logo_actual_size.png"]];
//    footer.frame = CGRectMake(0, 0, 270, FOOTERHEIGHT);
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, FOOTERHEIGHT)];
    [footerView addSubview:footer];
    return (section == 1) ? footerView : nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return (section == 1) ? 56 : 0;
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
            cell2.accessoryView.frame = CGRectMake(0, 0, CHECKMARKWIDTH, CHECKMARKHEIGHT);
            
        }
        else if (indexPath.section == 1) {
            UITableViewCell *cell = [self.table cellForRowAtIndexPath:selectedCollectorIndex];
            ((UIImageView *)(cell.accessoryView)).image = [UIImage imageNamed:@"nothing!!!!!!"];
            selectedCollectorIndex = indexPath;
            UITableViewCell *cell2 = [self.table cellForRowAtIndexPath:indexPath];
            cell2.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check_selected.png"]];
            cell2.accessoryView.frame = CGRectMake(0, 0, CHECKMARKWIDTH, CHECKMARKHEIGHT);
            
            
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
