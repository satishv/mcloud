//
//  GetStoriesForCollectionCommand.m
//  collectivly
//
//  Created by Nathan Fraenkel on 7/20/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import "GetStoriesForCollectionCommand.h"
#import "collectivlyCollection.h"

@implementation GetStoriesForCollectionCommand

@synthesize delegate, collection, page;

-(id)initWithCollection:(collectivlyCollection*)coll andPageNumber:(NSInteger)pNum {
    self = [super init];
    if (self) {
        // custom initialization
        self.collection = coll;
        self.page = pNum;
    }
    return self;
}

-(void)fetchStoriesForCollectionFromPage {
    NSLog(@"[GetStoriesForCollectionCommand] getting stories for collection %d: %@", collection.idNumber, collection.name);
    
    // spinnaz
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // set URL
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/stories/everyone/%d.json?page=%d", SERVER_MAIN_URL, collection.idNumber, page]];
        
    NSLog(@"[GetStoriesForCollectionCommand] fetching stories from page %d for collection with id: %d and name: %@", page, collection.idNumber, collection.name);
    
    // HTTP request, setting stuff
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:10] ;
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

#pragma mark connection protocol functions
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"[GetStoriesForCollectionCommand] conection did receive response!");
    _data = [[NSMutableData alloc] init];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"[GetStoriesForCollectionCommand] conection did receive data!");
    [_data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // Please do something sensible here, like log the error.
    NSLog(@"[GetStoriesForCollectionCommand] connection failed with error: %@", error.description);
    
    // stop spinners
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [self.delegate reactToGetStoriesError:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"[GetStoriesForCollectionCommand] connectiondidfinishloading!");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
 
    NSArray *responza = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
    
    NSLog(@"responza: %@", responza);
    
    storiesFromResponse = [self createStoriesFromResponse:responza];
    
    [self.delegate reactToGetStoriesResponse:[NSArray arrayWithArray:storiesFromResponse]];
    
}

#pragma mark helper
-(NSMutableArray *)createStoriesFromResponse:(NSArray*)array {
    NSLog(@"[GetStoriesForCollectionCommand] creating stories.");
    NSMutableArray *lolz = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; i++){
        NSLog(@"STORYYY %d out of %d", i, array.count);
        collectivlyStory *story = [[collectivlyStory alloc] initWithDictionaryWithoutFetchingImages:[array objectAtIndex:i]];
        NSLog(@"STORYYY %d out of %d DONE", i, array.count);
        [lolz addObject:story];
        
    }
    NSLog(@"[GetStoriesForCollectionCommand] DONE creating stories.");
    return lolz;
}




@end
