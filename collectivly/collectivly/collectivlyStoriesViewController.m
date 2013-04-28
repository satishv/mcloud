//
//  collectivlyStoriesViewController.m
//  collectivly
//
//  Created by Nathan Fraenkel on 4/19/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import "collectivlyStoriesViewController.h"

@interface collectivlyStoriesViewController ()

@end

@implementation collectivlyStoriesViewController

@synthesize currentUser, stories;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization

        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"[collectivlyStoriesViewController] viewdidload");
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshStories) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    self.currentUser = [collectivlySingleton sharedDataModel];
    
    self.title = self.currentUser.currentCollection.name;
    
    self.stories = self.currentUser.currentStories;
//    self.stories = [self.currentUser.storiesForCollectionWithId objectForKey:[NSString stringWithFormat:@"%d", self.currentUser.currentCollectionId]];
    NSLog(@"stories for id %d: %@", self.currentUser.currentCollection.idNumber, self.stories);
}

-(void)refreshStories {
    NSLog(@"REFRESHING STORIES");
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://collectivly.com/stories/everyone/11.json"]];
    NSLog(@"refreshing collection with id: %d", self.currentUser.currentCollection.idNumber);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://collectivly.com/stories/everyone/%d.json", self.currentUser.currentCollection.idNumber]];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // HTTP request, setting stuff
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.stories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIFont *customFont = [UIFont fontWithName:@"ProximaNovaCond-Semibold" size:17];
    
    NSLog(@" we in here for index: %d", indexPath.row);
    
    static NSString *CellIdentifier = @"StoryCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    collectivlyStory *story = [self.stories objectAtIndex:indexPath.row];
    UIImageView *storyImageView = (UIImageView *)[cell viewWithTag:100];
    storyImageView.image = story.articleImage;
    
    UILabel *storyNameLabel = (UILabel *)[cell viewWithTag:101];
    storyNameLabel.text = story.title;
    storyNameLabel.font = customFont;
    
    return cell;
}




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

-(NSMutableArray *)createStoriesFromResponse:(NSArray*)array {
    NSMutableArray *lolz = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; i++){
        NSLog(@"STORYYY %d: %@", i, [array objectAtIndex:i]);
        collectivlyStory *story = [[collectivlyStory alloc] initWithDictionary:[array objectAtIndex:i]];
        [lolz addObject:story];
        
    }
    return lolz;
}

#pragma mark connection protocol functions
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
    
    [self.refreshControl endRefreshing];
    
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
    switch (buttonIndex) {
        case 1:
            [self refreshStories];
            break;
        default:
            break;
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectiondidfinishloading!");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [self.refreshControl endRefreshing];
    
    NSMutableArray *newStories = [[NSMutableArray alloc] init];
    
    NSArray *array = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
    
    newStories = [self createStoriesFromResponse:array];
    
    if (self.currentUser.currentCollection != NULL) {
        // update singleton dictionary of stories for a collection
        //                [self.currentUser.storiesForCollectionWithId setObject:stories forKey:[NSString stringWithFormat:@"%d", selectedCollection]];
        [self.currentUser setCurrentStories:newStories];
        
        self.stories = newStories;
    }
    
    [self.tableView reloadData];
}


@end
